# Celebal Data Analysis Assignment - Week 2

This directory contains the database setup and analytical queries for the Week 2 E-Commerce dataset project. 

## Project Objective
The main goal of this task is to take transactional data from a mid-sized e-commerce platform  and perform a complete SQL-based data analysis. The workflow involves setting up relational constraints, validating data quality, applying optimal search indexes, and compiling business insights across customers, sales trends, and inventory metrics.

## Tables Created

* Customers
* Products
* Orders
* Order_Items

 ## SQL Concepts Covered

* CREATE DATABASE and CREATE TABLE
* Primary Key and Foreign Key
* Constraints (NOT NULL, UNIQUE, CHECK, DEFAULT)
* Indexes
* INSERT Statements
* SELECT Queries
* WHERE Clause
* GROUP BY and HAVING
* Aggregate Functions (COUNT, SUM, AVG, MIN, MAX)
* INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN
* CASE Statement
* Transactions (COMMIT and ROLLBACK)
---


### 1. Database Schema Design (Section A)
* Built a relational structure using 4 key entity tables: `customers`, `products`, `orders`, and `order_items`.
* Enforced structural integrity using strict data constraints, such as unique email locks and `CHECK` logic to prevent illegal data mutations (like negative prices or quantities).

### 2. Filtering & Performance Tuning (Section B)
* Implemented B-Tree storage index maps on heavily filtered paths (`order_date`, `status`, `city`, and `state`) to optimize lookups.
* Evaluated search architectures for SARGable compliance. Rewrote date filters to avoid using wrapped functions like `YEAR()`, allowing the engine to utilize physical indexes instead of doing heavy full-table scans.

### 3. Business Logic Aggregations (Section C & E)
* Compiled grouped reports using `GROUP BY` and `HAVING` matrices to isolate high-value product categories.
* Wrote single-row conditional tracking matrices by nesting conditional `CASE WHEN` logic inside math aggregate functions to break down multi-state shipping statuses effortlessly.

### 4. Relational Data Joins (Section D)
* Combined relational data maps across multiple tables (3-way table joins) using primary-to-foreign key mappings.
* Handled optional relations safely using `LEFT JOIN` rules to preserve missing data chains with clean `NULL` safety pads.

### 5. ACID Transaction Handling (Section E)
* Formulated an atomic `START TRANSACTION` multi-update query thread. 
* This bundle ensures that creating a customer order header, processing individual line items, and updating live inventory metrics happen simultaneously as a single atomic unit, preventing database desynchronization.

## Outcome
Successfully designed an E-Commerce Sales Database, inserted sample data, and solved all assignment queries using SQL while demonstrating database relationships, indexing, joins, aggregation, and transaction management.
