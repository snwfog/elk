require 'celluloid/current'
require 'connection_pool'
require 'faker'
require 'redis'

Benchmark.bm do |x|
  x.report do
    Array.new(100) do
      # looks like 100 thread is about a good balance between
      # the number of thread and the number of page view created
      Thread.new do
        50_000.times do |i|
          # print "#{i / 1000}%\r" if i % 1000 == 0
          butlers.async.page_view(visitors.sample, "#{Faker::Internet.url}/#{SecureRandom.hex(10)}", Time.now.utc)
        end
      end
    end.each(&:join)
  end
end

sleep 2000

$ids  = Array.new(1000) { SecureRandom.hex(8) }
$urls = Array.new(1_000) { Faker::Internet.url }

class Peon
  # include Celluloid
  def initialize(pool)
    @pool = pool
  end

  def work_work
    100_000.times do
      @pool.with do |conn|
        conn.pipelined do
          5.times do
            conn.zadd($ids.sample, Time.now.utc.to_f, $urls.sample)
          end
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
  # x.report('threaded') do
  #   redis_pool.with { |conn| conn.flushdb }
  #   t = 10.times.map do
  #     Thread.new do
  #       worker = Peon.new(redis_pool)
  #       100_000.times { worker.work_work }
  #     end
  #   end
  #
  #   t.map(&:join)
  # end

  x.report('celluloid async (fibered)') do
    redis_pool.with { |conn| conn.flushdb }
    Peon.include(Celluloid)
    class Grunt < Celluloid::Supervision::Container
    end

    grunt = Grunt.run!
    grunt.pool(Peon, as: :peons, args: [redis_pool], size: 10)
    10.times.map { |i|
      grunt[:peons].future.work_work }.map(&:value)
  end

  # x.report('celluloid async + celluloid redis (fibered)') do
  #   redis_pool.with { |conn| conn.flushdb }
  #   Peon.include(Celluloid)
  #   class Grunt < Celluloid::Supervision::Container
  #   end
  #
  #   grunt = Grunt.run!
  #   grunt.pool(Peon, as: :peons, args: [ConnectionPool.new(size: 10) { Redis.new(driver: :celluloid) }], size: 10)
  #   50_000.times { |i|
  #     if i % 1000 == 0
  #       print "Iteration #{i / 1000}\r"
  #       # fiber_count = 0
  #       # ObjectSpace.each_object(Fiber) { |fib| fiber_count += 1 if fib.alive? }
  #       # thread_count = 0
  #       # ObjectSpace.each_object(Thread) { |thread| thread_count += 1 }
  #       # p ['Iteration', i / 1000, 'Fiber counts', fiber_count, 'Thread counts', thread_count]
  #     end
  #
  #     grunt[:peons].async.work_work }
  # end
end
