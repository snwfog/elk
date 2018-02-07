====== PING_INLINE ======
  100000 requests completed in 1.75 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

98.54% <= 1 milliseconds
100.00% <= 1 milliseconds
57110.22 requests per second

====== PING_BULK ======
  100000 requests completed in 1.75 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.79% <= 1 milliseconds
100.00% <= 1 milliseconds
57175.53 requests per second

====== SET ======
  100000 requests completed in 1.85 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

90.61% <= 1 milliseconds
99.94% <= 2 milliseconds
99.95% <= 4 milliseconds
99.96% <= 5 milliseconds
99.99% <= 6 milliseconds
100.00% <= 6 milliseconds
53937.43 requests per second

====== GET ======
  100000 requests completed in 1.81 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

94.10% <= 1 milliseconds
100.00% <= 1 milliseconds
55279.16 requests per second

====== INCR ======
  100000 requests completed in 1.75 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.70% <= 1 milliseconds
100.00% <= 1 milliseconds
57273.77 requests per second

====== LPUSH ======
  100000 requests completed in 1.73 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.65% <= 1 milliseconds
100.00% <= 1 milliseconds
57870.37 requests per second

====== RPUSH ======
  100000 requests completed in 1.83 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

92.30% <= 1 milliseconds
100.00% <= 1 milliseconds
54794.52 requests per second

====== LPOP ======
  100000 requests completed in 1.73 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.69% <= 1 milliseconds
100.00% <= 1 milliseconds
57903.88 requests per second

====== RPOP ======
  100000 requests completed in 1.75 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

97.99% <= 1 milliseconds
99.99% <= 2 milliseconds
100.00% <= 2 milliseconds
57142.86 requests per second

====== SADD ======
  100000 requests completed in 1.74 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.83% <= 1 milliseconds
100.00% <= 1 milliseconds
57372.34 requests per second

====== HSET ======
  100000 requests completed in 1.76 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

97.10% <= 1 milliseconds
100.00% <= 1 milliseconds
56785.91 requests per second

====== SPOP ======
  100000 requests completed in 1.78 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

97.69% <= 1 milliseconds
100.00% <= 1 milliseconds
56242.97 requests per second

====== LPUSH (needed to benchmark LRANGE) ======
  100000 requests completed in 1.81 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

93.23% <= 1 milliseconds
100.00% <= 1 milliseconds
55279.16 requests per second

====== LRANGE_100 (first 100 elements) ======
  100000 requests completed in 4.23 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

6.67% <= 1 milliseconds
99.99% <= 2 milliseconds
100.00% <= 2 milliseconds
23618.33 requests per second

====== LRANGE_300 (first 300 elements) ======
  100000 requests completed in 10.13 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

0.01% <= 1 milliseconds
3.97% <= 2 milliseconds
95.56% <= 3 milliseconds
99.75% <= 4 milliseconds
99.95% <= 5 milliseconds
100.00% <= 5 milliseconds
9870.69 requests per second

====== LRANGE_500 (first 450 elements) ======
  100000 requests completed in 14.56 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

0.00% <= 1 milliseconds
0.02% <= 2 milliseconds
4.44% <= 3 milliseconds
92.07% <= 4 milliseconds
99.77% <= 5 milliseconds
99.98% <= 6 milliseconds
99.99% <= 7 milliseconds
99.99% <= 8 milliseconds
100.00% <= 8 milliseconds
6869.08 requests per second

====== LRANGE_600 (first 600 elements) ======
  100000 requests completed in 19.04 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

0.00% <= 1 milliseconds
0.01% <= 2 milliseconds
4.40% <= 3 milliseconds
27.13% <= 4 milliseconds
58.67% <= 5 milliseconds
87.39% <= 6 milliseconds
99.55% <= 7 milliseconds
99.90% <= 8 milliseconds
99.96% <= 9 milliseconds
99.99% <= 10 milliseconds
99.99% <= 11 milliseconds
100.00% <= 12 milliseconds
100.00% <= 12 milliseconds
5251.27 requests per second

====== MSET (10 keys) ======
  100000 requests completed in 1.67 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

97.10% <= 1 milliseconds
100.00% <= 1 milliseconds
59737.16 requests per second

