-- Write a query to find the total number of bookings made by each user, using the COUNT function and GROUP BY clause.
SELECT user_id, COUNT(booking_id) FROM booking GROUP BY user_id;

-- Use a window function (ROW_NUMBER, RANK) to rank properties based on the total number of bookings they have received.
-- get prop and their total bookings
SELECT property_id, COUNT(booking_id),
  RANK() OVER(ORDER BY COUNT(booking_id) DESC) as rank
  FROM booking GROUP BY property_id;
