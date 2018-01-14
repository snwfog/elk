require 'redis'
require 'thread'
require 'connection_pool'

pool = ConnectionPool.new(size: 10) { Redis.new }
pool.with do |conn|
  conn.del('queue')
  conn.del('lock')
  10.times do |i|
    conn.zadd('queue', i, i)
  end
end

Thread.abort_on_exception = true

Array.new(4) {
  Thread.new(pool) do |pool|
    loop {
      pool.with do |conn|
        tasks = conn.zrange('queue', 0, 0)
        next if tasks.empty?

        task_id       = tasks.first
        lock_acquired = conn.sadd('lock', task_id)

        puts "#{Thread.current.object_id} Lock acquired #{lock_acquired}, #{task_id}"
        if lock_acquired
          _removed = conn.zrem('queue', task_id)
          puts "#{Thread.current.object_id} Task dequeued #{_removed}, #{task_id}"
          raise 'Cannot remove an item that has not been acquired by lock' unless _removed

          puts "#{Thread.current.object_id} Processing item #{task_id}"
          (0..1_000_000).inject(:+)
          puts "#{Thread.current.object_id} Processed item #{task_id}, removing lock..."
          conn.srem('lock', task_id)
        end
      end
    }
  end
}.each(&:join)

