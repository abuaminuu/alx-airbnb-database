SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status as booking_status,
    b.created_at as booking_created,
    
    -- User details
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role as user_role,
    
    -- Property details
    p.property_id,
    p.name as property_name,
    p.description as property_description,
    p.location,
    p.pricepernight,
    p.host_id,
    
    -- Payment details
    py.payment_id,
    py.amount as payment_amount,
    py.payment_date,
    py.payment_method
    
FROM booking b
INNER JOIN "user" u ON b.user_id = u.user_id
INNER JOIN property p ON b.property_id = p.property_id
LEFT JOIN payment py ON b.booking_id = py.booking_id
ORDER BY b.created_at DESC;
