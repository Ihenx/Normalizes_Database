# Normalisation of Database
What is Normalisation of Database
Normalization of a Database is a process in database design used to organize data efficiently by eliminating redundancy (duplicate data) and ensuring data integrity. It involves structuring a database into multiple related tables based on specific rules, typically defined by a series of "normal forms." The goal is to minimize anomalies during data operations like insertion, updating, and deletion, while making the database more logical and easier to maintain.
### Key Concepts of Normalization:
* Redundancy Reduction: Prevents unnecessary duplication of data. For example, instead of storing a customer's name and email repeatedly in every sales record, they are stored once in a separate customers table.
* Data Integrity: Ensures accuracy and consistency by reducing the risk of anomalies (e.g., updating a customer's name in one place but not another).
* Relationships: Uses primary keys (unique identifiers) and foreign keys to link tables, allowing data to be retrieved efficiently via joins.
## Database Normalization Example
This repository contains an SQL script demonstrating the process of normalizing a database by restructuring a flat sales_records table into a relational database schema. The script creates related tables, establishes foreign key relationships, and removes redundant data to ensure data integrity and efficiency.
SQL Query Overview
The SQL script performs the following steps:
1. Create and Populate the customers Table
```
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    customer_phone VARCHAR(255),
    customer_email VARCHAR(255)
);
```
Creates a table for customer data with customer_id as the primary key.
Extracts unique customer records from sales_records.
```
INSERT INTO customers
SELECT DISTINCT customer_id,
      customer_name,
      customer_phone,
      customer_email
FROM
    sales_records;
```

2. Link sales_records to customers with a Foreign Key
  Establishes a relationship between sales_records and customers.
```
sql
ALTER TABLE sales_records
ADD CONSTRAINT sales_customer_id
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
ON DELETE CASCADE
ON UPDATE CASCADE;
```
Establishes a relationship between sales_records and customers.
4. Create and Populate the products Table
sql
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    product_price DEC(6,2)
);

Creates a table for products and populates it with unique product data.
```
INSERT IGNORE INTO products
SELECT DISTINCT product_id, product_name, product_price
FROM sales_records;
```
 Link sales_records to products
 ```
sql
ALTER TABLE sales_records
ADD CONSTRAINT sales_product_id
FOREIGN KEY (product_id) REFERENCES products(product_id)
ON DELETE CASCADE
ON UPDATE CASCADE;
```
 Create and Populate Additional Tables
Similar steps are repeated for:
categories (category_id, category_name)
countries (id, country)
payment_methods (id, payment_method)
Each table is populated with unique data from sales_records and linked via foreign keys.
6. Clean Up sales_records
```
sql
ALTER TABLE sales_records
    DROP COLUMN customer_name,
    DROP COLUMN customer_email,
    DROP COLUMN customer_phone,
    DROP COLUMN product_name,
    DROP COLUMN category_name,
    DROP COLUMN country_name,
    DROP COLUMN payment_method,
    DROP COLUMN product_price;
```
Removes redundant columns from sales_records after normalization.
