
INSERT INTO users (first_name, last_name, email, password_hash, phone_number, role)
VALUES 
('John', 'Doe', 'john@example.com', 'hashed_pass_1', '1234567890', 'guest'),
('Jane', 'Smith', 'jane@example.com', 'hashed_pass_2', '1234567891', 'host'),
('Alice', 'Brown', 'alice@example.com', 'hashed_pass_3', NULL, 'guest'),
('Bob', 'Taylor', 'bob@example.com', 'hashed_pass_4', '1234567892', 'admin'),
('Charlie', 'Adams', 'charlie@example.com', 'hashed_pass_5', '1234567893', 'guest'),
('Eve', 'Johnson', 'eve@example.com', 'hashed_pass_6', NULL, 'host'),
('Frank', 'White', 'frank@example.com', 'hashed_pass_7', '1234567894', 'guest'),
('Grace', 'Lee', 'grace@example.com', 'hashed_pass_8', '1234567895', 'guest'),
('Hank', 'Moore', 'hank@example.com', 'hashed_pass_9', '1234567896', 'host'),
('Ivy', 'Clark', 'ivy@example.com', 'hashed_pass_10', '1234567897', 'guest');


INSERT INTO properties (host_id, name, description, location, price_per_night)
VALUES
((SELECT user_id FROM users WHERE email='jane@example.com'), 'Cozy Apartment', 'Near city center', 'Lagos', 15000.00),
((SELECT user_id FROM users WHERE email='eve@example.com'), 'Beach House', 'Ocean view villa', 'Lekki', 45000.00),
((SELECT user_id FROM users WHERE email='hank@example.com'), 'Luxury Penthouse', 'Downtown high-rise', 'Abuja', 60000.00),
((SELECT user_id FROM users WHERE email='jane@example.com'), 'Modern Loft', 'Open-plan apartment', 'Ibadan', 20000.00),
((SELECT user_id FROM users WHERE email='eve@example.com'), 'Cabin Retreat', 'Private cabin with pool', 'Jos', 30000.00),
((SELECT user_id FROM users WHERE email='hank@example.com'), 'Budget Room', 'Affordable option', 'Kano', 8000.00),
((SELECT user_id FROM users WHERE email='jane@example.com'), 'City Condo', 'Heart of the business district', 'Lagos', 25000.00),
((SELECT user_id FROM users WHERE email='eve@example.com'), 'Mountain View', 'Scenic hill property', 'Enugu', 35000.00),
((SELECT user_id FROM users WHERE email='hank@example.com'), 'Studio Flat', 'Minimalist design', 'Abuja', 18000.00),
((SELECT user_id FROM users WHERE email='jane@example.com'), 'Garden Cottage', 'Quiet place with flowers', 'Abeokuta', 12000.00);


INSERT INTO bookings (property_id, user_id, start_date, end_date, total_price, status)
VALUES
((SELECT property_id FROM properties LIMIT 1 OFFSET 0),
 (SELECT user_id FROM users WHERE email='john@example.com'),
 '2025-11-01', '2025-11-05', 60000.00, 'confirmed'),

((SELECT property_id FROM properties LIMIT 1 OFFSET 1),
 (SELECT user_id FROM users WHERE email='charlie@example.com'),
 '2025-12-10', '2025-12-15', 225000.00, 'pending'),

((SELECT property_id FROM properties LIMIT 1 OFFSET 2),
 (SELECT user_id FROM users WHERE email='frank@example.com'),
 '2025-10-01', '2025-10-07', 420000.00, 'confirmed'),

((SELECT property_id FROM properties LIMIT 1 OFFSET 3),
 (SELECT user_id FROM users WHERE email='ivy@example.com'),
 '2025-08-10', '2025-08-12', 40000.00, 'canceled'),

((SELECT property_id FROM properties LIMIT 1 OFFSET 4),
 (SELECT user_id FROM users WHERE email='grace@example.com'),
 '2025-09-15', '2025-09-20', 150000.00, 'confirmed'),

((SELECT property_id FROM properties LIMIT 1 OFFSET 5),
 (SELECT user_id FROM users WHERE email='john@example.com'),
 '2025-10-05', '2025-10-06', 8000.00, 'pending'),

((SELECT property_id FROM properties LIMIT 1 OFFSET 6),
 (SELECT user_id FROM users WHERE email='charlie@example.com'),
 '2025-07-01', '2025-07-05', 100000.00, 'confirmed'),

((SELECT property_id FROM properties LIMIT 1 OFFSET 7),
 (SELECT user_id FROM users WHERE email='bob@example.com'),
 '2025-06-10', '2025-06-15', 175000.00, 'confirmed'),

((SELECT property_id FROM properties LIMIT 1 OFFSET 8),
 (SELECT user_id FROM users WHERE email='alice@example.com'),
 '2025-04-10', '2025-04-12', 36000.00, 'confirmed'),

((SELECT property_id FROM properties LIMIT 1 OFFSET 9),
 (SELECT user_id FROM users WHERE email='john@example.com'),
 '2025-05-20', '2025-05-22', 24000.00, 'pending');


INSERT INTO payments (booking_id, amount, payment_method)
SELECT booking_id, total_price, 
       (ARRAY['credit_card','paypal','stripe'])[floor(random()*3 + 1)]
FROM bookings;


INSERT INTO reviews (property_id, user_id, rating, comment)
SELECT b.property_id, b.user_id,
       (1 + floor(random()*5))::int AS rating,
       'Great stay, would recommend!'
FROM bookings b
WHERE b.status = 'confirmed'
LIMIT 10;


INSERT INTO messages (sender_id, recipient_id, message_body)
SELECT u1.user_id, u2.user_id,
       'Hello! Interested in your property.'
FROM users u1, users u2
WHERE u1.user_id <> u2.user_id
LIMIT 10;
