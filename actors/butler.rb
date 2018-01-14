# Butler
module Elk
  class Butler < ActorBase
    include Celluloid

    finalizer :on_finalize

    def page_view(env, request)
      timestamp = Time.now.utc
      et_id     = SecureRandom.hex(8)

      @t1_pool.with do |t1_conn|
        t1_conn.pipelined do
          t1_conn.zadd LAST_VISIT, timestamp.to_f, et_id
          { url:       request.url,
            referer:   request.referer,
            timestamp: timestamp.to_f,
            ip:        request.ip }.each do |k, v|
            t1_conn.hsetnx "#{PAGE_VIEW}:#{et_id}:#{timestamp.to_f}", k, v
          end
        end
      end
    end

    def on_finalize
      puts 'Finalizing'
    end
  end
end

