require 'celluloid/current'
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
  def initialize
    super()
    _initialize_actor_system
  end

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

  # 1. Make sure butlers and thread numbers are aligned
  # 2. Watch out for threading on mri ruby
  def _initialize_actor_system
    # runs in background (remove bang to run in foreground)
    # @director  = Elk::ButlerSupervisor.run!
    @core_size = 4
    @butlers   = Elk::Butler
                   .pool(as:   :butlers,
                         size: @core_size,
                         args: _connection_pools(@core_size))

    @collectors = Elk::Collector
                    .pool(as:   :collectors,
                          size: @core_size,
                          args: _connection_pools(@core_size * 25))
  end

  def _connection_pools(size)
    [ConnectionPool.new(size: size * 2) { Redis.new },
     ConnectionPool.new(size: size) {
       Cassandra.cluster.connect('tracking') }]
  end
end

run ElkApp