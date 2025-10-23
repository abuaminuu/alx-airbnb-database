# alx-airbnb-database

# 🏠 Airbnb-Database

The **Airbnb-Database** project is a relational database design inspired by Airbnb’s core functionality. It models essential entities such as **users**, **properties**, **bookings**, **payments**, **reviews**, and **messages**, capturing how guests, hosts, and administrators interact on a property rental platform.  

The schema is built using **PostgreSQL** and follows best practices in **database normalization** to reduce redundancy and ensure data integrity. Each table uses **UUIDs** for globally unique identification and maintains clear foreign key relationships to preserve referential consistency.  

This repository includes SQL scripts for:
- Creating all database tables and indexes (`schema.sql`)
- Populating the database with sample data for testing (`seed.sql`)
- Demonstrating normalization steps and principles (`normalization/` directory)

Together, these components provide a solid foundation for developers to build and test booking systems, analytics dashboards, or full-stack web applications.  

**Key Features**
- Clean, normalized schema structure  
<!-- Automated UUID generation via `pgcrypto`  -->
- Indexed relationships for performance  
- Ready-to-run sample data  

<!--
**Getting Started**
```bash
psql -U <username> -d <database_name> -f schema.sql
psql -U <username> -d <database_name> -f seed.sql
->