-- Views for dashboards & reuse

CREATE OR REPLACE VIEW v_monthly_revenue AS
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    SUM(p.payment_value) AS revenue,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2) AS aov
FROM orders o
JOIN order_payments p ON o.order_id = p.order_id
GROUP BY month;


CREATE OR REPLACE VIEW v_category_revenue AS
SELECT
    pt.product_category_name_english AS category,
    SUM(oi.price) AS revenue,
    COUNT(DISTINCT oi.order_id) AS orders
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
GROUP BY category;


CREATE MATERIALIZED VIEW IF NOT EXISTS mv_customer_rfm AS
SELECT
    c.customer_unique_id,
    (DATE '2018-10-01' - MAX(o.order_purchase_timestamp)::date) AS recency,
    COUNT(DISTINCT o.order_id) AS frequency,
    SUM(p.payment_value) AS monetary
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_payments p ON o.order_id = p.order_id
GROUP BY c.customer_unique_id;


CREATE INDEX IF NOT EXISTS idx_orders_purchase_ts ON orders(order_purchase_timestamp);
CREATE INDEX IF NOT EXISTS idx_orders_customer ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_items_order ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_items_product ON order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_items_seller ON order_items(seller_id);
CREATE INDEX IF NOT EXISTS idx_payments_order ON order_payments(order_id);
CREATE INDEX IF NOT EXISTS idx_reviews_order ON order_reviews(order_id);
CREATE INDEX IF NOT EXISTS idx_rfm_customer ON mv_customer_rfm(customer_unique_id);