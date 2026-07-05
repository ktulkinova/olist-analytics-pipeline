-- 1. Avg delivery days by month

SELECT DATE_TRUNC('month', order_purchase_timestamp) AS month, ROUND(AVG(order_delivered_customer_date::date - order_purchase_timestamp::date), 1) AS avg_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY month
ORDER BY month;

-- 2. Late orders %

SELECT COUNT(*) FILTER (WHERE order_delivered_customer_date > order_estimated_delivery_date) AS late_orders,
COUNT(*) AS total_delivered, ROUND(100.0 * COUNT(*) FILTER (WHERE order_delivered_customer_date > order_estimated_delivery_date) / COUNT(*), 2) AS late_pct
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

-- 3. Late vs on_time review score

SELECT
CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'late' ELSE 'on_time' END AS delivery,
ROUND(AVG(r.review_score), 2) AS avg_score,
COUNT(*) AS orders
FROM orders o
JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY delivery;
