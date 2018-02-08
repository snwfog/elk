require 'faye/websocket'
require 'json'
require 'redis'
require 'connection_pool'
require 'securerandom'

Faye::WebSocket.load_adapter('thin')

class VisitorLiveStreamApp
  CHANNEL_UPDATE = 0
  CHANNEL_JOIN   = 1
  CHANNEL_HITIT  = 2
  CHANNEL_CLOSE  = 3
  
  def initialize
    @pool    = ConnectionPool.new(size: 100) { Redis.new }
    @clients = []
  end
  
  def call(env)
    if Faye::WebSocket.websocket?(env)
      ws = Faye::WebSocket.new(env)
      
      ws.on :message do |event|
        # p [:message, event.data]
        request = JSON.parse(event.data)
        
        case request['type']
        when CHANNEL_HITIT
          core   = request['core']
          hits   = request['clicks']
          target = event.target
          client = @clients.first { |c| c[:ws] == target }
          hitit_broadcast("#{client.name} is hitting it with #{core} x #{hits} clicks!", from: target)
        when CHANNEL_UPDATE
          @pool.with do |conn|
            visitor_count = conn.scard("visitor:rollup:#{request['time']}")
            ws.send(JSON.dump(type:  CHANNEL_UPDATE,
                              time:  request['time'],
                              count: visitor_count))
          end
        end
      end
      
      ws.on :open do |event|
        target      = event.target
        client_name = "#{env['REMOTE_ADDR']} [#{SecureRandom.hex(4)}]"
        
        @clients << { ws:   target,
                      name: client_name }
        
        join_broadcast("#{client_name} has joined the party.")
      end
      
      ws.on :close do |event|
        # p [:close, event.code, event.reason]
        target         = event.target
        delete_clients = []
        @clients.each_with_index do |ws, index|
          if ws[:ws] == target
            delete_clients << index
            leave_broadcast("#{ws[:name]} has left the party.", from: target)
          end
        end
        
        delete_clients.each { |index| @clients.delete_at(index) }
      end
      # Return async Rack response
      ws.rack_response
      # else
      #   # Normal HTTP request
      #   [200, { 'Content-Type' => 'text/plain' }, ['Hello']]
    end
  end
  
  private
  def join_broadcast(msg)
    broadcast(msg, CHANNEL_JOIN, from: nil)
  end
  
  def hitit_broadcast(msg, from:)
    broadcast(msg, CHANNEL_HITIT, from: from)
  end
  
  def leave_broadcast(msg, from:)
    broadcast(msg, CHANNEL_CLOSE, from: from)
  end
  
  def broadcast(msg, event_type, from:)
    @clients.each do |client|
      unless from == client[:ws]
        client[:ws].send(JSON.dump(type: event_type, message: msg))
      end
    end
  end
end

run VisitorLiveStreamApp.new

# http://blog.honeybadger.io/building-a-simple-websockets-server-from-scratch-in-ruby/
# server = TCPServer.new('localhost', 2345)
# loop do
#   # Wait for a connection
#   socket = server.accept
#   STDERR.puts 'Incoming Request'
#
#   # Read the HTTP request. We know it's finished when we see a line with nothing but \r\n
#   http_request = ''
#   while (line = socket.gets) && (line != "\r\n")
#     http_request += line
#   end
#
#   if matches = http_request.match(/^Sec-WebSocket-Key: (\S+)/)
#     websocket_key = matches[1]
#     STDERR.puts "Websocket handshake detected with key: #{websocket_key}"
#   else
#     STDERR.puts "Aborting non-websocket connection"
#     socket.close
#     next
#   end
#
#   response_key = Digest::SHA1.base64digest([websocket_key, "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"].join)
#   STDERR.puts "Responding to handshake with key: #{ response_key }"
#
#   socket.write <<-eos
# HTTP/1.1 101 Switching Protocols
# Upgrade: websocket
# Connection: Upgrade
# Sec-WebSocket-Accept: #{ response_key }
#
#   eos
#   STDERR.puts http_request
#   STDERR.puts 'Handshake completed'
#   socket.close
# end