## ELK

A POC using actor model to handle visitor tracking
asynchronously. Uses Redis as an L1 cache, and Cassandra
backend storage (L2 cache possibly). Rough benchmark 
2200 req/s on a 4 core 2014 mac mini (generate + ingest).

Bonus: Websocket client + nice graph for peak usage.

jruby --server -J-Xms1500m -J-Xmx1500m elk.rb
puma --preload -t 8:16
