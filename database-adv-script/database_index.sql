-- Identify high-usage columns in your User, Booking, and Property tables (e.g., columns used in WHERE, JOIN, ORDER BY clauses).
-- and write SQL CREATE INDEX commands to create appropriate indexes for those columns.
  
-- User Table Indexes
CREATE INDEX index_user_email ON "user"(email);
CREATE INDEX index_user_role ON "user"(role);
CREATE INDEX index_user_created_at ON "user"(created_at);

-- Booking Table Indexes
CREATE INDEX index_booking_user_id ON booking(user_id);
CREATE INDEX index_booking_property_id ON booking(property_id);
CREATE INDEX index_booking_status ON booking(status);
CREATE INDEX index_booking_dates ON booking(start_date, end_date);
CREATE INDEX index_booking_created_at ON booking(created_at);

-- Property Table Indexes
CREATE INDEX index_property_host_id ON property(host_id);
CREATE INDEX index_property_location ON property(location);
CREATE INDEX index_property_price ON property(pricepernight);
CREATE INDEX index_property_created_at ON property(created_at);

-- Composite Indexes for Common Query Patterns
CREATE INDEX index_booking_user_status ON booking(user_id, status);
CREATE INDEX index_booking_property_dates ON booking(property_id, start_date, end_date);
CREATE INDEX index_property_location_price ON property(location, pricepernight);

-- Example 1: Frequently queried bookings per user and status
EXPLAIN ANALYZE
SELECT *
FROM booking
WHERE user_id = 101 AND status = 'confirmed';

-- Example 2: Search properties by location and price
EXPLAIN ANALYZE
SELECT *
FROM property
WHERE location = 'Lagos'
  AND pricepernight BETWEEN 5000 AND 10000
ORDER BY pricepernight ASC;

-- Example 3: Retrieve recent users
EXPLAIN ANALYZE
SELECT *
FROM "user"
WHERE created_at > NOW() - INTERVAL '30 days';
