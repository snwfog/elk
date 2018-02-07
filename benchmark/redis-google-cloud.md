====== PING_INLINE ======
  100000 requests completed in 0.78 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.96% <= 1 milliseconds
100.00% <= 1 milliseconds
127713.92 requests per second

====== PING_BULK ======
  100000 requests completed in 0.79 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.99% <= 1 milliseconds
100.00% <= 1 milliseconds
126422.25 requests per second

====== SET ======
  100000 requests completed in 0.84 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.88% <= 1 milliseconds
99.97% <= 2 milliseconds
100.00% <= 2 milliseconds
119474.31 requests per second

====== GET ======
  100000 requests completed in 0.85 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.79% <= 1 milliseconds
99.98% <= 2 milliseconds
100.00% <= 2 milliseconds
117785.63 requests per second

====== INCR ======
  100000 requests completed in 0.85 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.83% <= 1 milliseconds
99.97% <= 2 milliseconds
100.00% <= 2 milliseconds
117096.02 requests per second

====== LPUSH ======
  100000 requests completed in 0.86 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.83% <= 1 milliseconds
99.96% <= 2 milliseconds
100.00% <= 2 milliseconds
116686.12 requests per second

====== RPUSH ======
  100000 requests completed in 0.85 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.93% <= 1 milliseconds
100.00% <= 1 milliseconds
118063.76 requests per second

====== LPOP ======
  100000 requests completed in 0.86 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.85% <= 1 milliseconds
99.95% <= 2 milliseconds
100.00% <= 2 milliseconds
116550.12 requests per second

====== RPOP ======
  100000 requests completed in 0.85 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.88% <= 1 milliseconds
100.00% <= 1 milliseconds
117233.30 requests per second

====== SADD ======
  100000 requests completed in 0.85 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.91% <= 1 milliseconds
99.98% <= 2 milliseconds
100.00% <= 2 milliseconds
118203.30 requests per second

====== HSET ======
  100000 requests completed in 0.86 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.71% <= 1 milliseconds
99.97% <= 2 milliseconds
100.00% <= 2 milliseconds
116414.43 requests per second

====== SPOP ======
  100000 requests completed in 0.84 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.90% <= 1 milliseconds
99.99% <= 2 milliseconds
100.00% <= 2 milliseconds
118623.96 requests per second

====== LPUSH (needed to benchmark LRANGE) ======
  100000 requests completed in 0.85 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.78% <= 1 milliseconds
100.00% <= 1 milliseconds
117233.30 requests per second

====== LRANGE_100 (first 100 elements) ======
  100000 requests completed in 2.48 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.78% <= 1 milliseconds
99.85% <= 2 milliseconds
99.94% <= 3 milliseconds
100.00% <= 4 milliseconds
100.00% <= 4 milliseconds
40257.65 requests per second

====== LRANGE_300 (first 300 elements) ======
  100000 requests completed in 7.54 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

0.05% <= 1 milliseconds
91.97% <= 2 milliseconds
99.71% <= 3 milliseconds
99.92% <= 4 milliseconds
99.99% <= 5 milliseconds
100.00% <= 5 milliseconds
13257.32 requests per second

====== LRANGE_500 (first 450 elements) ======
  100000 requests completed in 10.62 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

0.02% <= 1 milliseconds
0.33% <= 2 milliseconds
98.96% <= 3 milliseconds
99.72% <= 4 milliseconds
99.97% <= 5 milliseconds
99.99% <= 6 milliseconds
100.00% <= 6 milliseconds
9412.65 requests per second

====== LRANGE_600 (first 600 elements) ======
  100000 requests completed in 13.71 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

0.01% <= 1 milliseconds
0.13% <= 2 milliseconds
5.67% <= 3 milliseconds
99.11% <= 4 milliseconds
99.65% <= 5 milliseconds
99.91% <= 6 milliseconds
99.96% <= 7 milliseconds
99.98% <= 8 milliseconds
99.99% <= 9 milliseconds
99.99% <= 10 milliseconds
100.00% <= 11 milliseconds
100.00% <= 12 milliseconds
7295.01 requests per second

====== MSET (10 keys) ======
  100000 requests completed in 1.34 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.86% <= 1 milliseconds
99.94% <= 2 milliseconds
100.00% <= 2 milliseconds
74626.87 requests per second