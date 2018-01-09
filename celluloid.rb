require 'celluloid/current'
require 'benchmark'
require 'faker'
require 'redis'
require 'connection_pool'
require 'securerandom'

class PageViewActor
  include Celluloid
  def initialize(pool)
    @pool = pool
  end

  def page_view(etid, url, timestamp)
    @pool.with do |conn|
      # if conn.exists("pageviews:#{etid}")
      #   last_visit = Time.at(conn.get("last_visit:#{etid}").to_i)
      #   visit_time = Time.at(timestamp)
      #   if last_visit < visit_time - 10.minutes
      #     puts "This visits is expired"
      #     puts "Signal cleanup to cleanup"
      #   end
      # end

      conn.pipelined do
        conn.set "last_visit:#{etid}", timestamp
        conn.hset "pageviews:#{etid}", timestamp, url
      end
    end
  end
end

redis_pool = ConnectionPool.new { Redis.new }
pool = PageViewActor.pool(args: [redis_pool])

visitors = 100.times.map { SecureRandom.hex(5) }

Benchmark.bm do |x|
  x.report do 
    10_000.times do
      pool.async.page_view(visitors.sample,
                           Faker::Internet.url, 
                           Time.now.to_i)
    end
  end
end

# pool = PrimeWorker.pool
# p Celluloid.cores
# (2..1000).each {|i| pool.async.prime(i)}
sleep 5

