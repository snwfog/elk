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
if ARGV[0] == 'info'
  page_views = client.keys('page_view:*').inject(0) { |m, et_id| m + client.zcard(et_id) }
  p ['Total page views', page_views]
  exit
end

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

require_relative './actors/butler'
require_relative './actors/collector'

class ButlerSupervisor < Celluloid::Supervision::Container
end

# watch out for threading on mri ruby
director = ButlerSupervisor.run!

# t1_pool == redis
# t2_pool == cassandra

t_size = 2
director.pool(Butler,
              as:   :butlers,
              size: t_size,
              args: [ConnectionPool.new(size: t_size) { Redis.new },
                     ConnectionPool.new(size: t_size) { Cassandra.cluster.connect('tracking') }])

butlers  = director[:butlers]
visitors = Array.new(1_000) { SecureRandom.hex(10) }

Benchmark.bm do |x|
  x.report do
    Array.new(10) do
      Thread.new do
        10_000.times do |i|
          # print "#{i / 1000}%\r" if i % 1000 == 0
          butlers.async.page_view(visitors.sample, "#{Faker::Internet.url}/#{SecureRandom.hex(10)}", Time.now.utc)
        end
      end
    end.each(&:join)
  end
end

sleep 2000

# 1. Make sure pool and thread numbers are aligned
