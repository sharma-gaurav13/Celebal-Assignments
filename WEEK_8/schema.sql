CREATE DATABASE ecommerce;
USE ecommerce;

CREATE TABLE customers (
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    email VARCHAR(100),
    registration_date DATE,
    customer_type VARCHAR(20)
);

CREATE TABLE products (
    product_id VARCHAR(20),
    product_name VARCHAR(100),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    cost_price FLOAT
);

CREATE TABLE orders (
    order_id VARCHAR(20),
    customer_id VARCHAR(20),
    order_date DATE,
    status VARCHAR(20),
    region_code VARCHAR(10)
);

CREATE TABLE order_items (
    item_id INT,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price FLOAT,
    discount_percent FLOAT,
    is_returned INT
);
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM products;