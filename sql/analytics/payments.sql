-- Payment methods share
SELECT
    payment_type,
    COUNT(*) AS orders,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct,
    ROUND(SUM(payment_value)::numeric, 2) AS total_value
FROM order_payments
GROUP BY payment_type
ORDER BY orders DESC;


-- Installments distribution
SELECT
    payment_installments,
    COUNT(*) AS orders,
    ROUND(AVG(payment_value), 2) AS avg_value
FROM order_payments
WHERE payment_type = 'credit_card'
GROUP BY payment_installments
ORDER BY payment_installments;


-- AOV: single vs installments
SELECT
    CASE WHEN payment_installments = 1 THEN 'single' ELSE 'installments' END AS type,
    COUNT(*) AS orders,
    ROUND(AVG(payment_value), 2) AS avg_value
FROM order_payments
WHERE payment_type = 'credit_card'
GROUP BY type;