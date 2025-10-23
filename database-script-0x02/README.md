# 🌱 Seed Data Script (`seed.sql`)

The `seed.sql` file contains SQL statements for populating the database with initial sample data used for testing and development. It inserts realistic entries into all major tables, including **users**, **properties**, **bookings**, **payments**, **reviews**, and **messages**. These records help simulate real-world interactions such as users listing properties, guests making bookings, and hosts receiving payments and feedback.

The script leverages PostgreSQL’s built-in `(UUID())` function to automatically generate unique identifiers for each record, ensuring data integrity across all relationships. It also uses foreign key references to maintain consistency between related tables (e.g., bookings linked to users and properties).

This dataset allows developers to quickly test features like queries, joins, constraints, and application logic without manually entering data. The seed values are intentionally lightweight and easy to modify, making it ideal for iterative testing and demos.

<-
**Usage:**
```bash
psql -U <username> -d <database_name> -f seed.sql
->
