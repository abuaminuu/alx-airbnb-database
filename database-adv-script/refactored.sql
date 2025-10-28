-- Optimized Query 1: Core booking information with essential details only
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status as booking_status,
    b.created_at as booking_created,
    
    -- Essential user details only
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    
    -- Essential property details only  
    p.property_id,
    p.name as property_name,
    p.location,
    p.pricepernight,
    
    -- Payment summary instead of full details
    py.payment_amount,
    py.payment_method
    
FROM booking b
INNER JOIN "user" u ON b.user_id = u.user_id
INNER JOIN property p ON b.property_id = p.property_id
LEFT JOIN (
    SELECT 
        booking_id,
        MAX(amount) as payment_amount,
        MAX(payment_method) as payment_method
    FROM payment 
    GROUP BY booking_id
) py ON b.booking_id = py.booking_id
WHERE b.created_at >= CURRENT_DATE - INTERVAL '6 months'  -- Recent bookings only
ORDER BY b.created_at DESC
LIMIT 100;  -- Pagination for UI
