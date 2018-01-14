# Collector
module Elk
  class Collector < ActorBase
    include Celluloid

    SESSION_EXPIRY_TIME = '2_seconds'.to_i.seconds
    TIME_FORMAT         = '%Y-%m-%d %H:%M:%S.%L'.freeze

    finalizer :on_finalize

    def initialize(t1_pool, t2_pool)
      super
      _prepare_batch_stmt
      @running_count = 0

      # This time slice should be decreased further
      every(0.01, &method(:collects))
    end

    def collects
      _with_expired_sessions do |expired_id|
        # p ['[Thread: %d] Expiring visitor %s (session #%d)' % [Thread.current.object_id, expired_id,
        #                                                        @running_count += 1]]
        t1_exec do |t1|
          page_views = t1.keys("#{PAGE_VIEW}:#{expired_id}:*")
          unless page_views.empty?
            t2_exec { |t2|
              stmt_batch = t2.batch do |batch|
                page_views.each do |page_view|
                  page_view_hsh = t1.hgetall(page_view)
                  batch.add(@insert_page_view_stmt,
                            arguments: [expired_id,
                                        Time.strptime(page_view_hsh['timestamp'], '%s.%L').utc,
                                        page_view_hsh['url'],
                                        page_view_hsh['referer']])
                end
              end
              t2.execute(stmt_batch)
            }
          end
        end
      end
    end

    def on_finalize
      if @lock_acquired
        puts ['Lock is acquired, must be freed before crashing... (%s)' % Actor.current]
      else
        puts ['Collector %s processed %d sessions...Will now exit.' % [Actor.current, @running_count]]
      end
    end

    private

    def _prepare_batch_stmt
      t2_exec do |t2|
        @insert_page_view_stmt = t2.prepare <<~SQL
          INSERT INTO page_views (
            id, 
            session_id, 
            timestamp,
            url, 
            referer)
          VALUES (NOW(), ?, ?, ?, ?)
        SQL

        # @insert_visitor_stmt = t2.prepare <<~SQL
        #   INSERT INTO visitors (
        #     id,
        #     session_id,
        #     ip_address,
        #     user_agent
        #   )
        #   VALUES (?, ?, ?, ?)
        # SQL
      end
    end

    def _with_expired_sessions(&blk)
      expired_id = nil

      t1_exec do |t1|
        expired_session_ids = t1.zrangebyscore(LAST_VISIT,
                                               0,
                                               SESSION_EXPIRY_TIME.ago.to_i,
                                               limit: [0, 1])
        return if expired_session_ids.empty?

        expired_id = expired_session_ids.first

        lock_acquired = t1.sadd(VISITOR_LOCK, expired_id)

        return unless lock_acquired

        _removed_visit = t1.zrem LAST_VISIT, expired_id
      end

      yield expired_id

      t1_exec do |t1|
        t1.multi do
          t1.srem VISITOR_LOCK, expired_id
          t1.del "#{PAGE_VIEW}:#{expired_id}:*"
        end
      end
    end
  end
end
