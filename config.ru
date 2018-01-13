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

    @pool ||= _initialize_actor_system
  end

  get('/collect') { handle_nonblock }
  post('/collect') { handle_nonblock }

  private

  def handle_nonblock
    @pool.async.page_view(env, request)
    'OK'
  end

  # Watch-out blocking future call
  def handle_then_respond
    time = Benchmark.realtime do
      @pool.future.page_view(env, request).value
    end

    '%0.4f' % time
  end

  # 1. Make sure pool and thread numbers are aligned
  # 2. Watch out for threading on mri ruby
  def _initialize_actor_system
    # runs in background (remove bang to run in foreground)
    # @director  = Elk::ButlerSupervisor.run!
    @core_size = 4
    # @director.pool(Elk::Butler,
    #                as:   :butlers,
    #                size: @core_size,
    #                args: [ConnectionPool.new(size: 2 * @core_size) { Redis.new },
    #                       ConnectionPool.new(size: @core_size) { Cassandra
    #                                                                .cluster
    #                                                                .connect('tracking') }])
    Elk::Butler
      .pool(
        as:   :butlers,
        size: @core_size,
        args: [ConnectionPool.new(size: 2 * @core_size) { Redis.new },
               ConnectionPool.new(size: @core_size) { Cassandra
                                                        .cluster
                                                        .connect('tracking') }])

    # @director.pool(Elk::Collector,
    #                as:   :collectors,
    #                size: @core_size,
    #                args: [ConnectionPool.new(size: 2 * @core_size) { Redis.new },
    #                       ConnectionPool.new(size: @core_size) { Cassandra
    #                                                                .cluster
    #                                                                .connect('tracking') }])
    # @butlers = @director[:butlers]
    # @collectors = @director[:collectors]
  end
end

run ElkApp