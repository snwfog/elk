require 'faye/websocket'
require 'connection_pool'
require 'securerandom'

Faye::WebSocket.load_adapter('thin')

class VisitorLiveStreamApp
  def initialize
    @pool = ConnectionPool.new(size: 100) { Redis.new }
  end

  def self.call(env)
    if Faye::WebSocket.websocket?(env)
      ws = Faye::WebSocket.new(env)

      ws.on :message do |event|
        p [:message, event, event.data]
        ws.send(event.data)
      end

      ws.on :close do |event|
        p [:close, event.code, event.reason]
        ws = nil
      end
      # Return async Rack response
      ws.rack_response
      # else
      #   # Normal HTTP request
      #   [200, { 'Content-Type' => 'text/plain' }, ['Hello']]
    end
  end
end

run VisitorLiveStreamApp
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