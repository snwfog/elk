# Butler
module Elk
  class Butler < ActorBase
    include Celluloid

    finalizer :on_finalize

    def page_view(et_id, url, timestamp)
      @t1_pool.with do |t1_conn|
        t1_conn.pipelined do
          t1_conn.zadd LAST_VISIT, timestamp.to_f, et_id
          t1_conn.zadd "#{PAGE_VIEW}:#{et_id}", timestamp.to_f, url
          t1_conn.hsetnx "#{VISITOR}:#{et_id}", :ip, Faker::Internet.ip_v4_address
        end
      end
    end

    def on_finalize
      puts 'Finalizing'
    end
  end
end

