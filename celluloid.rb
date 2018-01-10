require 'celluloid/current'
require 'benchmark'
require 'faker'
require 'redis'
require 'connection_pool'
require 'securerandom'
require 'sinatra/base'
require 'active_support/core_ext/numeric/time'
require 'cassandra'

client = Redis.new
client.flushdb
client.close

class ActorBase
  PAGE_VIEW  = 'page_view'.freeze
  LAST_VISIT = 'last_visit'.freeze
  VISITOR    = 'visitor'.freeze

  attr_reader :t1_pool
  attr_reader :t2_pool

  def initialize(t1_pool, t2_pool)
    @t1_pool = t1_pool
    @t2_pool = t2_pool
  end
end

class Butler < ActorBase
  include Celluloid


  def page_view(et_id, url, timestamp)
    t1_pool.with do |t1_conn|
      t1_conn.multi do
        t1_conn.zadd LAST_VISIT, timestamp.to_f, et_id
        t1_conn.hset "#{PAGE_VIEW}:#{et_id}", timestamp.to_f, url
        t1_conn.hsetnx "#{VISITOR}:#{et_id}", :ip, Faker::Internet.ip_v4_address
      end
    end
  end
end

class Collector < ActorBase
  include Celluloid

  SESSION_EXPIRY_TIME = '2_seconds'.to_i.seconds
  TIME_FORMAT         = '%Y-%m-%d %H:%M:%S.%L'.freeze

  finalizer :on_finalize

  def initialize(t1_pool, t2_pool)
    super
    every(1, &method(:collects))

    @running_count = 0
    t2_pool.with do |conn|
      @insert_page_view_stmt = conn.prepare <<~SQL
        INSERT INTO page_views (id, session_id, url, referer_url, created_at)
        VALUES (?, ?, ?, ?, ?)
      SQL
    end
  end

  def collects
    t1_pool.with do |t1_conn|
      # Dequeue 1 at a time
      expired_visit_session_ids = t1_conn.zrangebyscore(LAST_VISIT, 0,
                                                        SESSION_EXPIRY_TIME.ago.to_i,
                                                        limit: [rand(2), 1]) # <== LOL
      return if expired_visit_session_ids.empty?
      expired_visit_session_ids.each do |et_id|
        p ['[Thread: %d] Expiring visitor %s (session #%d)' % [Thread.current.object_id,
                                                               et_id,
                                                               @running_count += 1]]

        session_page_views = t1_conn.hgetall("#{PAGE_VIEW}:#{et_id}")
        t2_pool.with do |t2_conn|
          t2_conn.execute(
            t2_conn.batch do |batch|
              session_page_views.each do |timestamp, url|
                batch.add(@insert_page_view_stmt, arguments: [SecureRandom.hex(5).to_i(16),
                                                              et_id, url, url,
                                                              Time
                                                                .strptime(timestamp, '%s.%L')
                                                                .utc])
              end
            end
          )
        end
        t1_conn.multi do
          t1_conn.del "#{PAGE_VIEW}:#{et_id}"
          t1_conn.del "#{VISITOR}:#{et_id}"
          t1_conn.zrem LAST_VISIT, et_id
        end
      end
    end
  end

  def on_finalize
    puts ['Collector %s processed %d sessions...Will no exit.' % [self, @running_count]]
  end
end

class ButlerSupervisor < Celluloid::Supervision::Container
end

# watch out for threading on mri ruby
director = ButlerSupervisor.run!

# t1_pool
redis_pool = ConnectionPool.new(size: 5) { Redis.new }

# t2_pool
cassandra_pool = ConnectionPool.new(size: 5) { Cassandra.cluster.connect('tracking') }

pools = [redis_pool, cassandra_pool]
director.pool(Butler, as: :butlers, size: 2, args: pools)
# director.pool(Collector, as: :collectors, size: 2, args: pools)

butlers  = director[:butlers]
visitors = 100.times.map { SecureRandom.hex(5) }

Benchmark.bm do |x|
  x.report do
    100_000.times do
      butlers.async.page_view(visitors.sample, Faker::Internet.url, Time.now.utc)
    end
  end
end

sleep 100

# 1. Make sure pool and thread numbers are aligned
