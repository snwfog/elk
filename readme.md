## ELK

A POC using actor model to handle visitor tracking
asynchronously. Uses Redis as an L1 cache, and Cassandra
backend storage (L2 cache possibly). Rough benchmark 
2200 req/s on a 4 core 2014 mac mini (generate + ingest).

Bonus: Websocket client + nice graph for peak usage.

jruby --server -J-Xms1500m -J-Xmx1500m elk.rb
puma --preload -t 8:16

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

