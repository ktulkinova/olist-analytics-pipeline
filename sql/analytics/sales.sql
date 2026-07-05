
-- 1. Revenue by month

SELECT DATE_TRUNC('month', o.order_purchase_timestamp) AS month, SUM(p.payment_value) AS revenue
FROM orders o
JOIN order_payments p ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;

-- 2. Top-10 categories by revenue

SELECT pt.product_category_name_english AS category, SUM(oi.price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;

-- 3. AOV by month

SELECT DATE_TRUNC('month', o.order_purchase_timestamp) AS month, ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2) AS aov
FROM orders o
JOIN order_payments p ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;