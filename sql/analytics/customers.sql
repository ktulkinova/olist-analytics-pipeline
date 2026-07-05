
-- 1. Total vs repeat customers
SELECT COUNT(DISTINCT customer_unique_id) AS total_customers,
COUNT(DISTINCT CASE WHEN order_count > 1 THEN customer_unique_id END) AS repeat_customers,
ROUND(100.0 * COUNT(DISTINCT CASE WHEN order_count > 1 THEN customer_unique_id END)
/ COUNT(DISTINCT customer_unique_id), 2) AS repeat_rate_pct
FROM (
SELECT c.customer_unique_id, COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
) t;


-- 2. Top-10 states by customers
SELECT customer_state, COUNT(DISTINCT customer_unique_id) AS customers
FROM customers
GROUP BY customer_state
ORDER BY customers DESC
LIMIT 10;


-- 3. RFM segmentation

WITH rfm AS (
SELECT c.customer_unique_id, (DATE '2018-10-01' - MAX(o.order_purchase_timestamp)::date) AS recency,
COUNT(DISTINCT o.order_id) AS frequency,
SUM(p.payment_value) AS monetary
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_payments p ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
),
scored AS (
    SELECT
        customer_unique_id,
        NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency)     AS f_score,
        NTILE(5) OVER (ORDER BY monetary)      AS m_score
    FROM rfm
)
SELECT
    CASE
        WHEN r_score >= 4 AND f_score >= 4 THEN 'Champions'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'New customers'
        WHEN r_score <= 2 AND f_score >= 4 THEN 'At risk'
        WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost'
        ELSE 'Regular'
    END AS segment,
    COUNT(*) AS customers,
    ROUND(AVG(m_score), 2) AS avg_monetary_score
FROM scored
GROUP BY segment
ORDER BY customers DESC;