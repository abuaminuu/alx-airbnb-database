```sql
-- Performance Testing: Partitioned vs Non-Partitioned Queries

-- Test 1: Specific Date Range Query (Should trigger partition pruning)
EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT 
    booking_id, start_date, end_date, total_price, status
FROM booking
WHERE start_date BETWEEN '2024-01-01' AND '2024-03-31'
ORDER BY start_date;

-- Test 2: Current Month Bookings
EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    COUNT(*) as booking_count,
    SUM(total_price) as total_revenue
FROM booking
WHERE start_date >= DATE_TRUNC('month', CURRENT_DATE)
  AND start_date < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month';

-- Test 3: User's Recent Bookings (Join with partition key)
EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    b.booking_id, b.start_date, b.end_date, b.total_price,
    p.name as property_name, p.location
FROM booking b
INNER JOIN property p ON b.property_id = p.property_id
WHERE b.user_id = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'
  AND b.start_date >= CURRENT_DATE - INTERVAL '6 months'
ORDER BY b.start_date DESC;

-- Test 4: Property Availability Check (Date range with status)
EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    booking_id, start_date, end_date, status
FROM booking
WHERE property_id = 'b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a22'
  AND start_date BETWEEN '2024-02-01' AND '2024-02-29'
  AND status IN ('confirmed', 'pending')
ORDER BY start_date;

-- Test 5: Cross-Partition Query (Testing worst-case scenario)
EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    EXTRACT(YEAR FROM start_date) as year,
    EXTRACT(QUARTER FROM start_date) as quarter,
    COUNT(*) as bookings,
    AVG(total_price) as avg_price
FROM booking
WHERE start_date BETWEEN '2023-01-01' AND '2024-12-31'
  AND status = 'confirmed'
GROUP BY YEAR, QUARTER
ORDER BY YEAR, QUARTER;

-- Test 6: Partition Boundary Test
EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    booking_id, start_date, status
FROM booking
WHERE start_date BETWEEN '2023-12-28' AND '2024-01-05'  -- Crosses partition boundary
ORDER BY start_date;
```

## 📊 Expected Performance Results

### **Test 1: Specific Date Range**
**Expected Output:**
```
Append  (cost=0.00..1250.50 rows=15000 width=48)
  -> Seq Scan on booking_2024_q1  (cost=0.00..1250.50 rows=15000 width=48)
Planning Time: 0.5 ms
Execution Time: 25.8 ms
```

**Key Indicator:** Should only scan `booking_2024_q1` partition (partition pruning)

### **Test 2: Current Month**
**Expected Output:**
```
Append  (cost=0.00..850.25 rows=5000 width=48)
  -> Seq Scan on booking_2024_q1  (cost=0.00..850.25 rows=5000 width=48)
Planning Time: 0.3 ms  
Execution Time: 12.1 ms
```

### **Test 3: User's Recent Bookings**
**Expected Output:**
```
Nested Loop  (cost=0.29..45.67 rows=15 width=120)
  -> Index Scan using idx_booking_partitioned_user_date on booking_2024_q1
  -> Index Scan using idx_property_id on property
Planning Time: 0.8 ms
Execution Time: 1.2 ms
```

### **Test 4: Property Availability**
**Expected Output:**
```
Index Scan using idx_booking_partitioned_property_date on booking_2024_q1
Planning Time: 0.4 ms
Execution Time: 0.8 ms
```

## 🔍 Performance Analysis Queries

```sql
-- Check if partition pruning is working
SELECT schemaname, tablename, partitionschemaname, partitiontablename, partitionrank
FROM pg_catalog.pg_partitions 
WHERE tablename = 'booking';

-- Verify partition sizes and row counts
SELECT 
    schemaname,
    relname as partition_name,
    n_live_tup as row_count
FROM pg_stat_user_tables 
WHERE relname LIKE 'booking_2%'
ORDER BY relname;

-- Check partition usage in queries
SELECT 
    schemaname,
    relname as table_name,
    seq_scan,
    seq_tup_read,
    idx_scan,
    idx_tup_fetch
FROM pg_stat_user_tables 
WHERE relname LIKE 'booking_2%' OR relname = 'booking';

-- Analyze query plan to see partition elimination
EXPLAIN (ANALYZE, VERBOSE)
SELECT COUNT(*) 
FROM booking 
WHERE start_date BETWEEN '2024-01-01' AND '2024-01-31';
```

## 📈 Performance Comparison Metrics

### **Before Partitioning:**
```sql
-- Simulate non-partitioned performance
EXPLAIN (ANALYZE) 
SELECT COUNT(*) 
FROM booking_old  -- Original table
WHERE start_date BETWEEN '2024-01-01' AND '2024-01-31';
```

**Expected Result:**
```
Seq Scan on booking_old  (cost=0.00..125000.50 rows=5000 width=0)
Filter: ((start_date >= '2024-01-01'::date) AND (start_date <= '2024-01-31'::date))
Planning Time: 0.2 ms
Execution Time: 350.4 ms
```

### **After Partitioning:**
```
Append  (cost=0.00..1250.50 rows=5000 width=0)
  -> Seq Scan on booking_2024_q1  (cost=0.00..1250.50 rows=5000 width=0)
Planning Time: 0.5 ms
Execution Time: 12.3 ms
```

## 🎯 Key Performance Indicators to Monitor

1. **Partition Pruning**: Verify only relevant partitions are scanned
2. **Planning Time**: Should be slightly higher due to partition logic
3. **Execution Time**: Should be significantly faster for date-range queries
4. **Buffer Usage**: Reduced buffer reads due to smaller partitions
5. **Index Efficiency**: Smaller indexes per partition are faster to traverse

## 📋 Expected Performance Gains

| Query Type | Non-Partitioned | Partitioned | Improvement |
|------------|----------------|-------------|-------------|
| Single Month | 350ms | 12ms | 29x faster |
| Quarter Range | 1050ms | 25ms | 42x faster |
| User Recent | 45ms | 1.2ms | 37x faster |
| Cross-Year | 1400ms | 180ms | 8x faster |

The partitioned table should show dramatic improvements for date-range queries while maintaining similar performance for full-table operations.
