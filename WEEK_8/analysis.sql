-- TOTAL REVENUE
SELECT 
    SUM(quantity * unit_price) AS total_revenue
FROM order_items;

-- REVENUE PER CATEGORY
SELECT 
    p.category,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category;

-- TOP 10 CUSTOMERS BY SPENDING
SELECT 
    o.customer_id,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- RETURN ANALYSIS
SELECT 
    product_id,
    SUM(CASE WHEN is_returned = 1 THEN 1 ELSE 0 END) AS returns,
    COUNT(*) AS total_orders
FROM order_items
GROUP BY product_id;

-- PRODUCT RANKING USING WINDOW FUNCTION
SELECT 
    product_id,
    SUM(quantity * unit_price) AS revenue,
    DENSE_RANK() OVER (ORDER BY SUM(quantity * unit_price) DESC) AS rank_num
FROM order_items
GROUP BY product_id;

-- MONTHLY SALES TREND
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- TOP SELLING PRODUCTS
SELECT 
    product_id,
    SUM(quantity) AS total_sold
FROM order_items
GROUP BY product_id
ORDER BY total_sold DESC
LIMIT 10;

-- RETURN RATE ANALYSIS
SELECT 
    product_id,
    COUNT(*) AS total_orders,
    SUM(is_returned) AS returns,
    (SUM(is_returned) / COUNT(*)) * 100 AS return_rate
FROM order_items
GROUP BY product_id
ORDER BY return_rate DESC;


-- CUSTOMER ORDER FREQUENCY
SELECT 
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 10;