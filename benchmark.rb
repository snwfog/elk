require 'celluloid/current'
require 'celluloid/redis'
require 'connection_pool'
require 'faker'
require 'redis'

$ids  = Array.new(1000) { SecureRandom.hex(8) }
$urls = Array.new(1_000) { Faker::Internet.url }

class Peon
  # include Celluloid
  def initialize(pool)
    @pool = pool
  end
  
  def work_work
    @pool.with do |conn|
      conn.pipelined do
        5.times do
          conn.zadd($ids.sample, Time.now.utc.to_f, $urls.sample)
        end
      end
    end
  end
end

require 'benchmark'

redis_pool = ConnectionPool.new(size: 20) { Redis.new }
Benchmark.bm do |x|
  # user     system      total        real
  # sequential318.694000 143.833000 462.527000 (825.432641)
  # x.report('sequential') do
  #   worker = Peon.new(redis_pool)
  #   1_000_000.times { worker.work_work }
  # end
  
  # user     system      total        real
  # threaded254.828000 127.406000 382.234000 (382.953122)
  x.report('threaded') do
    redis_pool.with { |conn| conn.flushdb }
    t = 10.times.map do
      Thread.new do
        worker = Peon.new(redis_pool)
        1_000.times { worker.work_work }
      end
    end
    
    t.map(&:join)
  end
  
  x.report('celluloid async (fibered)') do
    redis_pool.with { |conn| conn.flushdb }
    Peon.include(Celluloid)
    worker_pool = Peon.pool(size: 10, args: [redis_pool])
    f           = nil
    10_000.times { f = worker_pool.future.work_work }
    f.value
  end
  
  redis_pool_celluloid = ConnectionPool.new(size: 10) { Redis.new(driver: :celluloid) }
  x.report('celluloid async + celluloid driver (fibered)') do
    redis_pool.with { |conn| conn.flushdb }
    Peon.include(Celluloid)
    worker_pool = Peon.pool(size: 10, args: [redis_pool_celluloid])
    f           = nil
    10_000.times { f = worker_pool.future.work_work }
    f.value
  end

end

