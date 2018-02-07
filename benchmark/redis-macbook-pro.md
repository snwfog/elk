====== PING_INLINE ======
  100000 requests completed in 2.09 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

87.87% <= 1 milliseconds
99.21% <= 2 milliseconds
99.55% <= 3 milliseconds
99.75% <= 4 milliseconds
99.91% <= 5 milliseconds
99.95% <= 83 milliseconds
99.97% <= 84 milliseconds
100.00% <= 84 milliseconds
47869.79 requests per second

====== PING_BULK ======
  100000 requests completed in 2.01 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

89.81% <= 1 milliseconds
99.59% <= 2 milliseconds
99.74% <= 3 milliseconds
99.90% <= 4 milliseconds
99.94% <= 5 milliseconds
99.95% <= 6 milliseconds
99.95% <= 12 milliseconds
99.95% <= 17 milliseconds
99.98% <= 18 milliseconds
100.00% <= 18 milliseconds
49875.31 requests per second

====== SET ======
  100000 requests completed in 1.99 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

91.81% <= 1 milliseconds
99.78% <= 2 milliseconds
99.80% <= 3 milliseconds
99.83% <= 4 milliseconds
99.88% <= 5 milliseconds
99.90% <= 8 milliseconds
99.92% <= 9 milliseconds
99.95% <= 10 milliseconds
99.95% <= 19 milliseconds
99.97% <= 20 milliseconds
100.00% <= 21 milliseconds
50377.83 requests per second

====== GET ======
  100000 requests completed in 1.97 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

91.30% <= 1 milliseconds
99.95% <= 2 milliseconds
99.97% <= 3 milliseconds
100.00% <= 3 milliseconds
50709.94 requests per second

====== INCR ======
  100000 requests completed in 1.95 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

93.17% <= 1 milliseconds
99.98% <= 2 milliseconds
100.00% <= 2 milliseconds
51255.77 requests per second

====== LPUSH ======
  100000 requests completed in 1.98 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

90.53% <= 1 milliseconds
99.46% <= 2 milliseconds
99.82% <= 3 milliseconds
100.00% <= 3 milliseconds
50632.91 requests per second

====== RPUSH ======
  100000 requests completed in 2.01 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

86.43% <= 1 milliseconds
99.65% <= 2 milliseconds
99.80% <= 3 milliseconds
99.97% <= 4 milliseconds
100.00% <= 4 milliseconds
49701.79 requests per second

====== LPOP ======
  100000 requests completed in 1.98 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

88.39% <= 1 milliseconds
100.00% <= 1 milliseconds
50632.91 requests per second

====== RPOP ======
  100000 requests completed in 1.98 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

87.11% <= 1 milliseconds
100.00% <= 1 milliseconds
50479.56 requests per second

====== SADD ======
  100000 requests completed in 2.01 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

84.65% <= 1 milliseconds
100.00% <= 1 milliseconds
49850.45 requests per second

====== SPOP ======
  100000 requests completed in 2.00 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

80.90% <= 1 milliseconds
99.95% <= 2 milliseconds
100.00% <= 2 milliseconds
50075.11 requests per second

====== LPUSH (needed to benchmark LRANGE) ======
  100000 requests completed in 2.01 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

74.44% <= 1 milliseconds
99.87% <= 2 milliseconds
99.91% <= 3 milliseconds
99.97% <= 4 milliseconds
100.00% <= 4 milliseconds
49751.24 requests per second

====== LRANGE_100 (first 100 elements) ======
  100000 requests completed in 4.45 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

5.64% <= 1 milliseconds
100.00% <= 2 milliseconds
100.00% <= 2 milliseconds
22482.01 requests per second

====== LRANGE_300 (first 300 elements) ======
  100000 requests completed in 10.72 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

0.00% <= 1 milliseconds
0.47% <= 2 milliseconds
87.37% <= 3 milliseconds
99.69% <= 4 milliseconds
99.95% <= 5 milliseconds
99.97% <= 6 milliseconds
99.98% <= 7 milliseconds
100.00% <= 8 milliseconds
100.00% <= 9 milliseconds
9331.84 requests per second

====== LRANGE_500 (first 450 elements) ======
  100000 requests completed in 15.98 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

0.00% <= 1 milliseconds
0.01% <= 2 milliseconds
1.79% <= 3 milliseconds
57.97% <= 4 milliseconds
98.44% <= 5 milliseconds
99.94% <= 6 milliseconds
99.95% <= 7 milliseconds
99.96% <= 8 milliseconds
99.96% <= 9 milliseconds
99.97% <= 10 milliseconds
99.98% <= 11 milliseconds
99.99% <= 12 milliseconds
99.99% <= 13 milliseconds
100.00% <= 14 milliseconds
100.00% <= 14 milliseconds
6259.00 requests per second

====== LRANGE_600 (first 600 elements) ======
  100000 requests completed in 21.63 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

0.00% <= 1 milliseconds
0.01% <= 2 milliseconds
0.03% <= 3 milliseconds
5.52% <= 4 milliseconds
35.51% <= 5 milliseconds
76.47% <= 6 milliseconds
97.90% <= 7 milliseconds
99.82% <= 8 milliseconds
99.94% <= 9 milliseconds
99.97% <= 10 milliseconds
99.98% <= 11 milliseconds
99.98% <= 12 milliseconds
99.99% <= 13 milliseconds
99.99% <= 14 milliseconds
100.00% <= 15 milliseconds
100.00% <= 16 milliseconds
4622.35 requests per second

====== MSET (10 keys) ======
  100000 requests completed in 2.34 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

12.63% <= 1 milliseconds
99.30% <= 2 milliseconds
100.00% <= 2 milliseconds
42753.31 requests per second