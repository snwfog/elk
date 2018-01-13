# Collector
module Elk
  class Collector < ActorBase
    include Celluloid

    SESSION_EXPIRY_TIME = '2_seconds'.to_i.seconds
    TIME_FORMAT         = '%Y-%m-%d %H:%M:%S.%L'.freeze

    finalizer :on_finalize

    def initialize(t1_pool, t2_pool)
      super
      # every(1, &method(:collects))

      @running_count = 0
      @t2_pool.with do |conn|
        @insert_page_view_stmt = conn.prepare <<~SQL
          INSERT INTO page_views (
            id, 
            session_id, 
            url, 
            referer_url)
          VALUES (?, ?, ?, ?)
        SQL
      end

      async.collects
    end

    def collects
      loop {
        # @t1_pool.with do |t1_conn|
        #   # Dequeue 1 at a time
        #   expired_session_ids = t1_conn.zrangebyscore(LAST_VISIT, 0, SESSION_EXPIRY_TIME.ago.to_i, limit: [0, 1])
        #   return if expired_session_ids.empty?
        #   expired_session_ids.each do |et_id|
        #     p ['[Thread: %d] Expiring visitor %s (session #%d)' % [Thread.current.object_id,
        #                                                            et_id,
        #                                                            @running_count += 1]]
        #
        #     return if t1_conn.keys("#{PAGE_VIEW}:#{et_id}")
        #
        #     @t2_pool.with do |t2_conn|
        #       t2_conn.execute(
        #         t2_conn.batch do |batch|
        #           t1_conn
        #             .zrange("#{PAGE_VIEW}:#{et_id}", 0, -1, with_scores: true)
        #             .each do |timestamp, url|
        #             batch.add(@insert_page_view_stmt,
        #                       arguments: [SecureRandom.hex(5).to_i(16),
        #                                   et_id, url, url,
        #                                   Time
        #                                     .strptime(timestamp, '%s.%L')
        #                                     .utc])
        #           end
        #         end
        #       )
        #     end
        #
        #     t1_conn.multi do
        #       t1_conn.del "#{PAGE_VIEW}:#{et_id}"
        #       t1_conn.del "#{VISITOR}:#{et_id}"
        #       t1_conn.zrem LAST_VISIT, et_id
        #     end
        #   end
        # end
      }
    end

    def on_finalize
      puts ['Collector %s processed %d sessions...Will no exit.' % [self, @running_count]]
    end
  end
end
