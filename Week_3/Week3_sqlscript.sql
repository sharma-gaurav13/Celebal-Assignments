-- Database for week3 
CREATE DATABASE celebal_week3;

USE celebal_week3;

SHOW TABLES;

SELECT *
FROM superstore_raw
LIMIT 2;

-- check type of each column 
DESC superstore_raw;

-- create table customers 
CREATE TABLE customers (
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code INT,
    region VARCHAR(20)
);

-- Don't make `Customer ID` as a PRIMARY KEY because in superstore_raw 
-- there are dulicate `Customer ID`
INSERT INTO customers
SELECT DISTINCT
    `Customer ID`,
    `Customer Name`,
    Segment,
    Country,
    City,
    State,
    `Postal Code`,
    Region
FROM superstore_raw;

-- check the table customer
SELECT COUNT(*)
FROM  customers;


-- create table orders 
CREATE TABLE orders (
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(20)
);

-- Insert values in orders table 
INSERT INTO orders
SELECT DISTINCT
    `Order ID`,
    STR_TO_DATE(`Order Date`, '%m/%d/%Y'),
    STR_TO_DATE(`Ship Date`, '%m/%d/%Y'),
    `Ship Mode`,
    `Customer ID`
FROM superstore_raw;

SELECT COUNT(*)
FROM orders;



-- create table products 
CREATE TABLE products (
    order_id VARCHAR(20),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    product_id VARCHAR(30),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(200),
    sales DOUBLE,
    quantity INT,
    discount DOUBLE,
    profit DOUBLE
);

-- Insert values in table products 
INSERT INTO products
SELECT DISTINCT
    `Order ID`,
    `Customer ID`,
    `Customer Name`,
    `Product ID`,
    Category,
    `Sub-Category`,
    `Product Name`,
    Sales,
    Quantity,
    Discount,
    Profit
FROM superstore_raw;

-- check products
SELECT COUNT(*)
FROM products; 

-- 1.	Find all orders where sales are greater than the average sales. (Subquery) 
SELECT *
FROM products
WHERE sales > (SELECT AVG(sales) FROM products);

-- 2.	Find the highest sales order for each customer. (Subquery) 
SELECT p.customer_id, p.order_id, p.sales
FROM products p
JOIN (
    SELECT customer_id, MAX(sales) AS max_sales
    FROM products
    GROUP BY customer_id
) t
ON p.customer_id = t.customer_id
AND p.sales = t.max_sales;

-- 3.	Calculate total sales for each customer. (CTE) 
WITH total_sales_of_each_customer AS (
    SELECT customer_id, customer_name, ROUND(SUM(sales), 3) AS total_sales
    FROM products
    GROUP BY customer_id, customer_name
)
SELECT *
FROM total_sales_of_each_customer;

-- 4.	Find customers whose total sales are above average. (CTE + Subquery)
WITH total_sales_of_customers AS (
    SELECT customer_id, customer_name, ROUND(SUM(sales), 3) AS total_sales
    FROM products
    GROUP BY customer_id, customer_name
)
SELECT *
FROM total_sales_of_customers
WHERE total_sales > (SELECT AVG(total_sales) FROM total_sales_of_customers); 

-- 5.	Rank all customers based on total sales. (Window Function)
WITH total_sales_of_customers AS (
    SELECT customer_id, customer_name, ROUND(SUM(sales), 3) AS total_sales
    FROM products
    GROUP BY customer_id, customer_name
)
SELECT customer_id, customer_name, total_sales,
RANK() OVER (ORDER BY total_sales DESC) AS customer_rank
FROM total_sales_of_customers; 

-- 6.	Assign row numbers to each order within a customer. (Window Function + PARTITION BY) 
SELECT customer_id, customer_name, order_id,
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_id) AS row_num
FROM products; 


-- Q7. Display top 3 customers based on total sales. (Window Function)
WITH customer_sales AS (
    SELECT customer_id, customer_name, SUM(sales) AS total_sales
    FROM products
    GROUP BY customer_id, customer_name
)
SELECT *
FROM (
    SELECT customer_id, customer_name, total_sales,
        RANK() OVER (ORDER BY total_sales DESC) AS customer_rank
    FROM customer_sales
) ranked_customers
WHERE customer_rank <= 3;

-- Final Query Customer Name, Total Sales, Rank (JOIN + CTE + Window Function)
WITH customer_sales AS (
    SELECT p.customer_id, SUM(p.sales) AS total_sales
    FROM products p
    GROUP BY p.customer_id
)
SELECT
    c.customer_name, cs.total_sales,
    RANK() OVER (ORDER BY cs.total_sales DESC) AS customer_rank
FROM customer_sales cs
JOIN customers c
ON cs.customer_id = c.customer_id;

-- ===================================================================
                    -- Mini Project: Customer Sales Insights
-- ==================================================================== 

-- 1.	Who are the top 5 customers?
WITH total_customers_sales AS (
    SELECT customer_id, customer_name, SUM(sales) AS total_sales
    FROM products
    GROUP BY customer_id, customer_name
)
SELECT *
FROM total_customers_sales
ORDER BY total_sales DESC
LIMIT 5;

-- 2.	Who are the bottom 5 customers? 
WITH customer_sales AS (
    SELECT customer_id, customer_name, SUM(sales) AS total_sales
    FROM products
    GROUP BY customer_id, customer_name
)
SELECT *
FROM customer_sales
ORDER BY total_sales ASC
LIMIT 5; 

-- 3.	Which customers made only one order? 
SELECT customer_id, customer_name, COUNT(DISTINCT order_id) AS total_orders
FROM products
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT order_id) = 1; 

-- 4.	Which customers have above-average sales?
WITH customer_sales AS (
    SELECT customer_id, customer_name, SUM(sales) AS total_sales
    FROM products
    GROUP BY customer_id, customer_name
)
SELECT *
FROM customer_sales
WHERE total_sales > (SELECT AVG(total_sales) FROM customer_sales); 

-- 5.	What is the highest order value per customer? 
SELECT customer_id, customer_name, MAX(sales) AS highest_order_value
FROM products
GROUP BY customer_id, customer_name;