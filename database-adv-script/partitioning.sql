-- Assume the Booking table is large and query performance is slow. Implement partitioning on the Booking table based on the start_date column

-- Step 1: Create partitioned table structure
CREATE TABLE booking_partitioned (
    booking_id UUID DEFAULT gen_random_uuid(),
    property_id UUID REFERENCES property(property_id),
    user_id UUID REFERENCES "user"(user_id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL NOT NULL,
    status VARCHAR(20) CHECK (status IN ('pending', 'confirmed', 'canceled')) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (booking_id, start_date)
) PARTITION BY RANGE (start_date);

-- Step 2: Create partitions for different time periods

-- Historical data partition (before 2023)
CREATE TABLE booking_historical PARTITION OF booking_partitioned
    FOR VALUES FROM ('2000-01-01') TO ('2023-01-01');

-- 2023 partitions by quarter
CREATE TABLE booking_2023_q1 PARTITION OF booking_partitioned
    FOR VALUES FROM ('2023-01-01') TO ('2023-04-01');

CREATE TABLE booking_2023_q2 PARTITION OF booking_partitioned
    FOR VALUES FROM ('2023-04-01') TO ('2023-07-01');

CREATE TABLE booking_2023_q3 PARTITION OF booking_partitioned
    FOR VALUES FROM ('2023-07-01') TO ('2023-10-01');

CREATE TABLE booking_2023_q4 PARTITION OF booking_partitioned
    FOR VALUES FROM ('2023-10-01') TO ('2024-01-01');

-- 2024 partitions by quarter
CREATE TABLE booking_2024_q1 PARTITION OF booking_partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

CREATE TABLE booking_2024_q2 PARTITION OF booking_partitioned
    FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');

CREATE TABLE booking_2024_q3 PARTITION OF booking_partitioned
    FOR VALUES FROM ('2024-07-01') TO ('2024-10-01');

CREATE TABLE booking_2024_q4 PARTITION OF booking_partitioned
    FOR VALUES FROM ('2024-10-01') TO ('2025-01-01');

-- Future partitions (for ongoing operations)
CREATE TABLE booking_2025_q1 PARTITION OF booking_partitioned
    FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');

-- Default partition for any unexpected dates
CREATE TABLE booking_future PARTITION OF booking_partitioned DEFAULT;

-- Step 3: Create indexes on partitioned table
CREATE INDEX idx_booking_partitioned_start_date ON booking_partitioned(start_date);
CREATE INDEX idx_booking_partitioned_user_id ON booking_partitioned(user_id);
CREATE INDEX idx_booking_partitioned_property_id ON booking_partitioned(property_id);
CREATE INDEX idx_booking_partitioned_created_at ON booking_partitioned(created_at);
CREATE INDEX idx_booking_partitioned_status ON booking_partitioned(status);

-- Composite indexes for common query patterns
CREATE INDEX idx_booking_partitioned_user_date ON booking_partitioned(user_id, start_date);
CREATE INDEX idx_booking_partitioned_property_date ON booking_partitioned(property_id, start_date);

-- Step 4: Data migration from old table (run during maintenance window)
INSERT INTO booking_partitioned 
SELECT * FROM booking;

-- Step 5: Verification and switchover (after successful migration)
-- 1. Verify row counts match
SELECT 
    (SELECT COUNT(*) FROM booking) as old_count,
    (SELECT COUNT(*) FROM booking_partitioned) as new_count;

-- 2. Rename tables for switchover
ALTER TABLE booking RENAME TO booking_old;
ALTER TABLE booking_partitioned RENAME TO booking;

-- Step 6: Create automatic partition creation function
CREATE OR REPLACE FUNCTION create_booking_partitions()
RETURNS void AS $$
BEGIN
    -- Create next quarter's partition if it doesn't exist
    EXECUTE format(
        'CREATE TABLE IF NOT EXISTS booking_%s PARTITION OF booking FOR VALUES FROM (%L) TO (%L)',
        to_char(CURRENT_DATE + INTERVAL '3 months', 'YYYY_q'),
        DATE_TRUNC('quarter', CURRENT_DATE + INTERVAL '3 months'),
        DATE_TRUNC('quarter', CURRENT_DATE + INTERVAL '6 months')
    );
END;
$$ LANGUAGE plpgsql;

-- Step 7: Create maintenance script for partition management
-- This would typically run monthly via cron job or scheduled task

-- Example query leveraging partition pruning
EXPLAIN ANALYZE
SELECT *
FROM booking
WHERE start_date BETWEEN '2024-01-01' AND '2024-03-31'
  AND status = 'confirmed';
