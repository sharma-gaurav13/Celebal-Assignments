
-- =======================================================
-- SCHEMA SETUP & INDEXES
-- =======================================================

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    join_date DATE NOT NULL,
    is_premium BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_cust_city ON customers(city);
CREATE INDEX idx_cust_state ON customers(state);

CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
    stock_qty INT NOT NULL DEFAULT 0 CHECK (stock_qty >= 0)
);

CREATE INDEX idx_prod_cat ON products(category);

CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')),
    total_amount DECIMAL(12,2) NOT NULL CHECK (total_amount >= 0),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE INDEX idx_ord_date ON orders(order_date);
CREATE INDEX idx_ord_status ON orders(status);

CREATE TABLE IF NOT EXISTS order_items (
    item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
    discount_pct DECIMAL(5,2) DEFAULT 0 CHECK (discount_pct BETWEEN 0 AND 100),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


-- =======================================================
-- SAMPLE DATA INSERTION
-- =======================================================

INSERT IGNORE INTO customers VALUES
(101, 'Aarav', 'Sharma', 'aarav.s@email.com', 'Mumbai', 'Maharashtra', '2024-01-15', TRUE),
(102, 'Priya', 'Patel', 'priya.p@email.com', 'Ahmedabad', 'Gujarat', '2024-02-20', FALSE),
(103, 'Rohan', 'Gupta', 'rohan.g@email.com', 'Delhi', 'Delhi', '2024-03-10', TRUE),
(104, 'Sneha', 'Reddy', 'sneha.r@email.com', 'Hyderabad', 'Telangana', '2024-04-05', FALSE),
(105, 'Vikram', 'Singh', 'vikram.s@email.com', 'Jaipur', 'Rajasthan', '2024-05-12', TRUE),
(106, 'Ananya', 'Iyer', 'ananya.i@email.com', 'Chennai', 'Tamil Nadu', '2024-06-18', FALSE),
(107, 'Karan', 'Mehta', 'karan.m@email.com', 'Pune', 'Maharashtra', '2024-07-22', TRUE),
(108, 'Divya', 'Nair', 'divya.n@email.com', 'Kochi', 'Kerala', '2024-08-30', FALSE);

INSERT IGNORE INTO products VALUES
(201, 'Wireless Earbuds', 'Electronics', 'BoAt', 1499.00, 250),
(202, 'Cotton T-Shirt', 'Clothing', 'Levi''s', 799.00, 500),
(203, 'Smart Watch', 'Electronics', 'Noise', 2999.00, 150),
(204, 'Running Shoes', 'Clothing', 'Nike', 4599.00, 120),
(205, 'Bluetooth Speaker', 'Electronics', 'JBL', 3499.00, 200),
(206, 'Bedsheet Set', 'Home', 'Spaces', 1299.00, 300),
(207, 'Laptop Stand', 'Electronics', 'AmazonBasics', 899.00, 180),
(208, 'Cushion Covers (Set)', 'Home', 'HomeCenter', 599.00, 400);

INSERT IGNORE INTO orders VALUES
(1001, 101, '2024-08-01', 'Delivered', 4498.00),
(1002, 102, '2024-08-03', 'Delivered', 799.00),
(1003, 103, '2024-08-05', 'Shipped', 7498.00),
(1004, 101, '2024-08-10', 'Delivered', 3499.00),
(1005, 104, '2024-08-12', 'Cancelled', 2999.00),
(1006, 105, '2024-08-15', 'Delivered', 5898.00),
(1007, 106, '2024-08-18', 'Pending', 1299.00),
(1008, 103, '2024-08-20', 'Delivered', 899.00),
(1009, 107, '2024-08-25', 'Shipped', 6098.00),
(1010, 108, '2024-08-28', 'Delivered', 1598.00);

INSERT IGNORE INTO order_items VALUES
(5001, 1001, 201, 2, 1499.00, 0),
(5002, 1001, 207, 1, 899.00, 10),
(5003, 1002, 202, 1, 799.00, 0),
(5004, 1003, 203, 1, 2999.00, 0),
(5005, 1003, 204, 1, 4599.00, 5),
(5006, 1004, 205, 1, 3499.00, 0),
(5007, 1005, 203, 1, 2999.00, 0),
(5008, 1006, 201, 1, 1499.00, 10),
(5009, 1006, 204, 1, 4599.00, 5),
(5010, 1007, 206, 1, 1299.00, 0),
(5011, 1008, 207, 1, 899.00, 0),
(5012, 1009, 205, 1, 3499.00, 0),
(5013, 1009, 208, 2, 599.00, 15),
(5014, 1010, 206, 1, 1299.00, 0),
(5015, 1010, 208, 1, 599.00, 0);



-- Q1
SELECT * FROM customers;

-- Q2
SELECT first_name, last_name, city FROM customers;

-- Q3
SELECT DISTINCT category FROM products;

/* Q4: Primary Keys are:
  - customers table: customer_id
  - products table: product_id
  - orders table: order_id
  - order_items table: item_id
  
  Why unique and NOT NULL? Because it enforces row identity. If a key allows duplicates or NULL values, 
  relational consistency fails since there would be no clean way to reference specific lines across tables.
*/

/* Q5: Constraints on email: UNIQUE and NOT NULL.
  If you try to put a duplicate email, MySQL drops Error 1062 (Duplicate entry) and blocks the insert.
*/

/* Q6: Trying negative unit_price drops a CHECK constraint error.
  INSERT INTO products (product_id, product_name, category, brand, unit_price) 
  VALUES (210, 'Fail Mock', 'Home', 'Test', -25.00);
*/


-- =======================================================
-- SECTION B: FILTERING & OPTIMIZATION
-- =======================================================

-- Q7
SELECT * FROM orders WHERE status = 'Delivered';

-- Q8
SELECT * FROM products WHERE category = 'Electronics' AND unit_price > 2000;

-- Q9
SELECT * FROM customers WHERE state = 'Maharashtra' AND join_date BETWEEN '2024-01-01' AND '2024-12-31';

-- Q10
SELECT * FROM orders WHERE order_date BETWEEN '2024-08-10' AND '2024-08-25' AND status != 'Cancelled';

-- Q11: Index idx_orders_date speeds up lookups by avoiding full table reads.
SELECT order_id, customer_id, total_amount FROM orders WHERE order_date = '2024-08-15';

-- Q12: Running YEAR(join_date) invalidates lookups because functions break standard index checking.
-- Index-safe fix:
SELECT * FROM customers WHERE join_date >= '2024-01-01' AND join_date <= '2024-12-31';


-- =======================================================
-- SECTION C: AGGREGATION
-- =======================================================

-- Q13
SELECT COUNT(*) AS total_orders FROM orders;

-- Q14
SELECT SUM(total_amount) AS delivered_revenue FROM orders WHERE status = 'Delivered';

-- Q15
SELECT category, AVG(unit_price) AS avg_price FROM products GROUP BY category;

-- Q16
SELECT status, COUNT(*) AS order_count, SUM(total_amount) AS total_revenue 
FROM orders 
GROUP BY status 
ORDER BY total_revenue DESC;

-- Q17
SELECT category, MAX(unit_price) AS max_price, MIN(unit_price) AS min_price 
FROM products 
GROUP BY category;

-- Q18
SELECT category, AVG(unit_price) AS avg_price 
FROM products 
GROUP BY category 
HAVING avg_price > 2000;


-- =======================================================
-- SECTION D: JOINS & RELATIONSHIPS
-- =======================================================

-- Q19
SELECT o.order_id, o.order_date, c.first_name, c.last_name, o.total_amount 
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Q20
SELECT c.*, o.order_id, o.order_date, o.total_amount 
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- Q21
SELECT oi.order_id, p.product_name, oi.quantity, oi.unit_price, oi.discount_pct 
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id;

/*
Q22: LEFT JOIN gives you all parents on the left, pulling matching child details if any exist.
     RIGHT JOIN focuses on keeping all right records alive even if parent records are completely missing.
     FULL OUTER JOIN keeps everything on both sides, patching unmatched cells with NULL.
*/

/*
Q23: Foreign Keys map dependencies. Putting an order under non-existing customer_id 999 
     breaks constraints, throwing Error 1452 (Cannot add or update child row).
*/


-- =======================================================
-- SECTION E: ADVANCED CONCEPTS
-- =======================================================

-- Q24
SELECT product_name, unit_price,
       CASE 
           WHEN unit_price < 1000 THEN 'Budget'
           WHEN unit_price BETWEEN 1000 AND 3000 THEN 'Mid-Range'
           ELSE 'Premium'
       END AS price_tier
FROM products;

-- Q25
SELECT 
    SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_count,
    SUM(CASE WHEN status != 'Delivered' THEN 1 ELSE 0 END) AS not_delivered_count
FROM orders;

/*
Q26: ACID breakdowns:
  - Atomicity: Transact all actions smoothly or revert everything clean if any step drops out.
  - Consistency: Ensures validations (like checking non-zero keys or datatypes) stay solid.
  - Isolation: Keeps concurrent lookups running on independent, private threads.
  - Durability: Guarantees updates commit firmly to disk storage logs so failures won't wipe them.
*/

-- Q27: Basic atomic insert sequence
SET SQL_SAFE_UPDATES = 0;
START TRANSACTION;

INSERT INTO orders (order_id, customer_id, order_date, status, total_amount)
VALUES (1011, 102, '2026-06-28', 'Pending', 1598.00);

INSERT INTO order_items (item_id, order_id, product_id, quantity, unit_price, discount_pct)
VALUES (5016, 1011, 202, 1, 799.00, 0.00),
       (5017, 1011, 202, 1, 799.00, 0.00);

UPDATE products 
SET stock_qty = stock_qty - 2 
WHERE product_id = 202;

COMMIT;
SET SQL_SAFE_UPDATES = 1;
