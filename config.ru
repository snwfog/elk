require 'celluloid/current'
require 'erb'
require 'rack'
require 'faker'
require 'sinatra'
require 'cassandra'

require_relative './elk'

client = Redis.new
if ARGV[0] == 'info'
  page_views = client.keys('page_view:*').inject(0) { |m, et_id| m + client.zcard(et_id) }
  p ['Total page views', page_views]
  exit
end

client.flushdb
client.close

# ElkApp
class ElkApp < Sinatra::Base
  VISITOR_ROLL_UP_KEY = 'visitor:rollup'.freeze

  enable :inline_templates

  def initialize
    super

    @core_size = 4

    _initialize_pool
    _initialize_actor_system
  end

  before('/collect') { _rollup_visits }

  get('/') { erb :index }

  get('/collect') { handle_nonblock }
  post('/collect') { handle_nonblock }

  private

  def handle_nonblock
    @butlers.async.page_view(env, request)
    'OK'
  end

  # Watch-out blocking future call
  def handle_then_respond
    time = Benchmark.realtime do
      @butlers.future.page_view(env, request).value
    end

    '%0.4f' % time
  end

  def _initialize_pool
    @redis, @cassandra = _connection_pools(@core_size)
  end

  # 1. Make sure butlers and thread numbers are aligned
  # 2. Watch out for threading on mri ruby
  def _initialize_actor_system
    # runs in background (remove bang to run in foreground)
    # @director  = Elk::ButlerSupervisor.run!
    @butlers = Elk::Butler.pool(as:   :butlers,
                                size: @core_size,
                                args: _connection_pools(@core_size))

    @collectors = Elk::Collector.pool(as:   :collectors,
                                      size: @core_size,
                                      args: _connection_pools(@core_size * 25))
  end

  def _connection_pools(size)
    [ConnectionPool.new(size: size * 2) { Redis.new },
     ConnectionPool.new(size: size) {
       Cassandra.cluster.connect('tracking') }]
  end

  def _rollup_visits
    @redis.with do |conn|
      conn.sadd("#{VISITOR_ROLL_UP_KEY}:#{Time.now.utc.to_i}", SecureRandom.hex(10))
    end
  end
end

run ElkApp
