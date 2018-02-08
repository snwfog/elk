====== PING_INLINE ======
  100000 requests completed in 0.88 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.89% <= 1 milliseconds
100.00% <= 1 milliseconds
113507.38 requests per second

====== PING_BULK ======
  100000 requests completed in 0.89 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.82% <= 1 milliseconds
99.98% <= 2 milliseconds
100.00% <= 2 milliseconds
112485.94 requests per second

====== SET ======
  100000 requests completed in 0.87 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.79% <= 1 milliseconds
99.93% <= 2 milliseconds
100.00% <= 2 milliseconds
115606.94 requests per second

====== GET ======
  100000 requests completed in 0.86 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.87% <= 1 milliseconds
100.00% <= 1 milliseconds
116279.07 requests per second

====== INCR ======
  100000 requests completed in 0.86 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.72% <= 1 milliseconds
99.95% <= 2 milliseconds
100.00% <= 2 milliseconds
116414.43 requests per second

====== LPUSH ======
  100000 requests completed in 0.86 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.92% <= 1 milliseconds
99.97% <= 2 milliseconds
100.00% <= 2 milliseconds
115874.86 requests per second

====== LPOP ======
  100000 requests completed in 0.88 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.89% <= 1 milliseconds
100.00% <= 1 milliseconds
113765.64 requests per second

====== SADD ======
  100000 requests completed in 0.88 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.85% <= 1 milliseconds
99.97% <= 2 milliseconds
100.00% <= 2 milliseconds
113507.38 requests per second

====== SPOP ======
  100000 requests completed in 0.92 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.82% <= 1 milliseconds
100.00% <= 1 milliseconds
108813.92 requests per second

====== LPUSH (needed to benchmark LRANGE) ======
  100000 requests completed in 1.13 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.69% <= 1 milliseconds
99.99% <= 2 milliseconds
100.00% <= 2 milliseconds
88183.43 requests per second
====== LRANGE_100 (first 100 elements) ======
  100000 requests completed in 1.92 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1
99.33% <= 1 milliseconds
99.94% <= 2 milliseconds
100.00% <= 2 milliseconds
52056.22 requests per second
====== LRANGE_300 (first 300 elements) ======
  100000 requests completed in 4.90 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1
4.83% <= 1 milliseconds
97.89% <= 2 milliseconds
99.99% <= 3 milliseconds
100.00% <= 3 milliseconds
20399.84 requests per second
====== LRANGE_500 (first 450 elements) ======
  100000 requests completed in 7.46 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1
0.02% <= 1 milliseconds
81.64% <= 2 milliseconds
99.34% <= 3 milliseconds
99.97% <= 4 milliseconds
100.00% <= 4 milliseconds
13403.03 requests per second
====== LRANGE_600 (first 600 elements) ======
  100000 requests completed in 9.73 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1
0.02% <= 1 milliseconds
6.46% <= 2 milliseconds
95.41% <= 3 milliseconds
98.83% <= 4 milliseconds
99.81% <= 5 milliseconds
99.98% <= 6 milliseconds
99.99% <= 7 milliseconds
100.00% <= 7 milliseconds
10280.66 requests per second
====== MSET (10 keys) ======
  100000 requests completed in 1.09 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1
99.41% <= 1 milliseconds
99.97% <= 2 milliseconds
100.00% <= 2 milliseconds
91743.12 requests per second