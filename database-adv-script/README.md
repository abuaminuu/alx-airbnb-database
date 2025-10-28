# JOINing Queries

This collection demonstrates fundamental SQL JOIN operations using a property booking database schema. The queries showcase different JOIN types for retrieving related data across multiple tables.

**Key Features:**
- **INNER JOIN**: Retrieves all bookings with their corresponding user details, ensuring only matched records from both tables are returned. Perfect for finding complete booking-user relationships.

- **LEFT JOIN**: Fetches all properties including those without any reviews, maintaining the complete property dataset while optionally including review information where available.

- **FULL OUTER JOIN**: Comprehensive query that returns all users and all bookings, preserving records even when no matches exist. This captures users without bookings and orphaned bookings simultaneously.

These queries serve as essential building blocks for reporting, analytics, and data retrieval in relational databases, demonstrating practical applications of JOIN operations for real-world business scenarios.
# SQL Query Optimization Project

## Overview
This project demonstrates SQL query optimization techniques using a property booking database schema. The implementation focuses on writing efficient queries, creating strategic indexes, and measuring performance improvements.

## Key Features

### Query Implementation
- **JOIN Operations**: Mastered INNER, LEFT, and FULL OUTER JOINs to retrieve related data across User, Booking, and Property tables
- **Aggregate Queries**: Utilized COUNT with GROUP BY to analyze booking patterns per user
- **Window Functions**: Implemented ROW_NUMBER() to rank properties by booking volume
- **Subqueries**: Developed correlated and non-correlated subqueries for advanced filtering

### Performance Optimization
- **Index Strategy**: Identified high-usage columns in WHERE, JOIN, and ORDER BY clauses
- **Index Types**: Created single-column, composite, and covering indexes for common query patterns
- **Performance Measurement**: Used EXPLAIN ANALYZE to compare query execution plans before and after indexing

## Technical Stack
- PostgreSQL Database
- Standard SQL with PostgreSQL extensions
- Performance analysis using EXPLAIN and ANALYZE
- UUID primary keys for scalable data design

## Learning Outcomes
This project provides practical experience in database optimization, from writing basic queries to implementing advanced performance tuning strategies. The techniques demonstrated are applicable to real-world applications requiring efficient data retrieval and analysis.

## Usage
Each SQL file contains commented examples and performance benchmarks. Run the queries in sequence to observe the optimization process from initial implementation to performance-tuned solutions.
