# Collector
module Elk
  class Collector < ActorBase
    include Celluloid

    SESSION_EXPIRY_TIME = '2_seconds'.to_i.seconds
    TIME_FORMAT         = '%Y-%m-%d %H:%M:%S.%L'.freeze

    finalizer :on_finalize

    def initialize(t1_pool, t2_pool)
      super
      _prepare_stmt
      @running_count = 0

      every(0.1, &method(:collects))
    end

    def collects
      @t1_pool.with do |t1_conn|
        # Dequeue 1 at a time
        et_id = t1_conn.zrangebyscore(LAST_VISIT,
                                      0,
                                      SESSION_EXPIRY_TIME.ago.to_i,
                                      limit: [0, 1])

        # try to get lock and process this visitor
        lock_acquired = t1_conn.hsetnx(VISITOR_LOCK, et_id)
        return unless lock_acquired
        t1_conn.zrem LAST_VISIT, et_id

        return unless et_id
        p ['[Thread: %d] Expiring visitor %s (session #%d)' % [Thread.current.object_id,
                                                               et_id,
                                                               @running_count += 1]]
        page_views = t1_conn.keys("#{PAGE_VIEW}:#{et_id}:*")
        unless page_views.empty?
          @t2_pool.with do |t2_conn|
            stmt_batch = t2_conn.batch do |batch|
              page_views.each do |page_view|
                page_view_hsh = t1_conn.hgetall(page_view)
                batch.add(@insert_page_view_stmt,
                          arguments: [Time.strptime(page_view_hsh['timestamp'], '%s.%L').utc,
                                      et_id,
                                      page_view_hsh['url'],
                                      page_view_hsh['referer']])
              end
            end
            t2_conn.execute(stmt_batch)
          end

          t1_conn.del "#{PAGE_VIEW}:#{et_id}:*"
        end
      end
    end

    def on_finalize
      puts ['Collector %s processed %d sessions...Will no exit.' % [self, @running_count]]
    end

    private

    def _prepare_stmt
      @t2_pool.with do |conn|
        @insert_page_view_stmt = conn.prepare <<~SQL
          INSERT INTO page_views (
            id, 
            session_id, 
            url, 
            referer)
          VALUES (?, ?, ?, ?)
        SQL

        @insert_visitor_stmt = conn.prepare <<~SQL
          INSERT INTO visitors (
          )
          VALUES (?, ?, ?)
        SQL
      end
    end
  end
end
