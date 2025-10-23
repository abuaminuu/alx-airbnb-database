-- users table
CREATE TABLE User (
    user_id INT Primary Key, (UUID()),
    first_name VARCHAR(64), NOT NULL,
    last_name VARCHAR(64), NOT NULL,
    email VARCHAR(64), UNIQUE, NOT NULL,
    password_hash VARCHAR(64), NOT NULL,
    phone_number VARCHAR(64), NULL,
    role ENUM(guest, host, admin), NOT NULL,
    created_at TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
);

-- property table
CREATE  TABLE Property (
    property_id INT Primary Key, (UUID()), 
    host_id Foreign Key, references User(user_id),
    name VARCHAR(64), NOT NULL,
    description TEXT, NOT NULL,
    location VARCHAR(64), NOT NULL,
    pricepernight DECIMAL, NOT NULL,
    created_at TIMESTAMP, DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP
);

-- booking table
CREATE TABLE Booking (
    booking_id INT Primary Key, (UUID()), 
    property_id Foreign Key, references Property(property_id),
    user_id Foreign Key, references User(user_id),
    start_date DATE, NOT NULL,
    end_date DATE, NOT NULL,
    total_price DECIMAL, NOT NULL,
    status ENUM (pending, confirmed, canceled), NOT NULL,
    created_at TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
);

-- payment table
CREATE TABLE Payment (
    payment_id INT Primary Key, (UUID()), 
    booking_id Foreign Key, references Booking(booking_id),
    amount DECIMAL, NOT NULL,
    payment_date TIMESTAMP, DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM (credit_card, paypal, stripe), NOT NULL
);

-- review table
CREATE TABLE Review (
    review_id INT Primary Key, (UUID()),
    property_id Foreign Key, references Property(property_id),
    user_id Foreign Key, references User(user_id),
    rating INTEGER, CHECK rating >= 1 AND rating <= 5, NOT NULL,
    comment TEXT, NOT NULL,
    created_at TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
);

-- message table
CREATE TABLE Message (
    message_id INT Primary Key, (UUID()),
    sender_id Foreign Key, references User(user_id),
    recipient_id Foreign Key, references User(user_id),
    message_body TEXT, NOT NULL,
    sent_at TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
);


-- creating indexes on required columns(foreign,composite and filters)

CREATE INDEX index_user_id ON User(user_id);
CREATE INDEX index_email ON User(emai);

CREATE INDEX index_host_id ON Property(host_id);

CREATE INDEX index_user_id ON Booking(user_id);
CREATE INDEX index_property_id,  ON Booking(property_id);
CREATE INDEX index_booking_id ON Payment(booking_id);

CREATE INDEX index_property_id ON Review(property_id);
CREATE INDEX index_user_id ON Review(user_id);

CREATE INDEX index_sender_id ON Message(sender_id);
CREATE INDEX index_recipient_id ON Message(recipient_id);

-- add index for date filters during search
CREATE INDEX index_created_at ON Property(created_at);

