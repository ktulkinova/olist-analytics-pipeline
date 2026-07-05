-- 1. Top-10 sellers by revenue
SELECT oi.seller_id, s.seller_state, SUM(oi.price) AS revenue, COUNT(DISTINCT oi.order_id) AS orders
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY oi.seller_id, s.seller_state
ORDER BY revenue DESC
LIMIT 10;


-- 2. Sellers by state
SELECT seller_state, COUNT(*) AS sellers
FROM sellers
GROUP BY seller_state
ORDER BY sellers DESC
LIMIT 10;


-- 3. Avg review score per seller (min 50 orders)
SELECT oi.seller_id, COUNT(DISTINCT oi.order_id) AS orders, ROUND(AVG(r.review_score), 2) AS avg_score
FROM order_items oi
JOIN order_reviews r ON oi.order_id = r.order_id
GROUP BY oi.seller_id
HAVING COUNT(DISTINCT oi.order_id) >= 50
ORDER BY avg_score DESC
LIMIT 10;