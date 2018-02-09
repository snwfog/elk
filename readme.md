## ELK

A POC using actor model to handle visitor tracking
asynchronously. Uses Redis as an L1 cache, and Cassandra
backend storage (L2 cache possibly). Rough benchmark
2200 req/s on a 4 core 2014 mac mini (generate + ingest).

Bonus: Websocket client + nice graph for peak usage.

### Installation / Requirements

- Ruby 2.3+ / JRuby
- Cassandra 3, Redis (either install through docker or locally)
- run `rackup` to startup the normal server
- - default uses puma, but webrick is okay
- curl 'http://localhost:9292/collect' to send visit
- run `RACK_ENV=production rackup -p 9293 script/websocket.ru -s thin`
- - starts websocket
- - navigate browser to 'http://localhost:9292/' to view websocket graph
- if on window, uses sb -c 10 -n 10000 -u 'http://localhost:9292/collect'
- else if on unix, uses ab, or wrk
- Use 'script/setup.sh' for linux box

jruby --server -J-Xms1500m -J-Xmx1500m elk.rb
RACK_ENV=production bundle exec puma -t 8:8

JAVA_OPTS='-Xms4g -Xmx4g'
wrk -c10000 -t4 -d30s http://localhost:9292/collect

sudo ps aux | grep thin | cut -f3 -d' ' | xargs -I{} kill -9 {}
bundle exec thin -C script/thin_elk.yml start
bundle exec thin start -R script/websocket.ru -p 9282 --daemon
# bundle exec thin -C script/thin_ws.yml start

curl --include \
     --no-buffer \
     --header "Connection: Upgrade" \
     --header "Upgrade: websocket" \
     --header "Host: example.com:80" \
     --header "Origin: http://example.com:80" \
     --header "Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==" \
     --header "Sec-WebSocket-Version: 13" \
     http://localhost:9282/

curl --include \
     --no-buffer \
     --header "Connection: Upgrade" \
     --header "Upgrade: websocket" \
     --header "Host: example.com:80" \
     --header "Origin: http://example.com:80" \
     --header "Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==" \
     --header "Sec-WebSocket-Version: 13" \
     http://35.186.168.165/ws

ab -n10000 -c16 http://35.199.18.131/collect

http://s1564.t.eloqua.com/visitor/v200/svrGP.aspx?pps=3&siteid=1564&ref=http%3A%2F%2Fwww.google.com&elqNone&tzo=300&ms=131&optin=disabled
curl 'http://s1564.t.eloqua.com/visitor/v200/svrGP.aspx?pps=3&siteid=1564&ref=http%3A%2F%2Fwww.google.com&elqNone&tzo=300&ms=131&optin=disabled&elqCookie=1' -H 'Cookie: ELOQUA=GUID=3D37FD59FD0D4EA687469089CB52605A; ELQSTATUS=OK'
ab -n10 -c4 -H'Cookie: ELOQUA=GUID=3D37FD59FD0D4EA687469089CB52605A; ELQSTATUS=OK' 'http://s1564.t.eloqua.com/visitor/v200/svrGP.aspx?pps=3&siteid=1564&ref=http%3A%2F%2Fwww.google.com&elqNone&tzo=300&ms=131&optin=disabled&elqCookie=1'

