## After carefull analysis of the Entity Relation Model of the Database, The following observation is made:

1. it is apparent that the Users table treats everybody as a single user by uniquely applying Primary Key constraint on each row, this helped us achieved **1NF**.

2. secondy, **2NF** is achieved by validating entries using ENUM, this help us get only permitted roles per user to avoid creating redundant table for different roles.

we also make sure the each entity on the table are functionaly dependent on Primary Key. Eg in the Property Table, all the non-key attributes/entities(name, description, location, price...icluding Foreign keys) rely solely on the instance of a property itself based on the primary key. No incomplete information (secondry dependency)for a particular entry insde Property Table.

3. To achieve  **3NF**, we make sure that all the attributes(including the non-key attributes & foreign keys) of the table functionally depend on table's Primary key. Eg in Message Table, each of the attribute sender, reciever, message and time_sent did not rely on anyother attribute amongst them.

## 3NF Violation will be:
In this scenario, let's assume that we add property_owner_id to the Booking Table and is functionally dependent on property_id (i.e., each property is owned by one property owner). This would create a transitive dependency:
booking_id → property_id → property_owner_id
Here, property_owner_id depends on property_id, which in turn depends on booking_id. This violates 3NF because property_owner_id is a non-key attribute that depends on another non-key attribute (property_id).
