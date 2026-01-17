-- ------------------------------------------------------------
-- 05_analysis_queries.sql
-- Extra queries used for insights + charts
-- ------------------------------------------------------------

-- 1) Delivery funnel proxy (logistics progression)
SELECT
  COUNT(*) FILTER (WHERE order_purchase_timestamp IS NOT NULL) AS purchased,
  COUNT(*) FILTER (WHERE order_approved_at IS NOT NULL) AS approved,
  COUNT(*) FILTER (WHERE order_delivered_carrier_date IS NOT NULL) AS shipped,
  COUNT(*) FILTER (WHERE order_delivered_customer_date IS NOT NULL) AS delivered
FROM orders;

-- 2) Repeat customer %
WITH customer_orders AS (
  SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders
  FROM customers c
  JOIN orders o
    ON o.customer_id = c.customer_id
  WHERE o.order_purchase_timestamp IS NOT NULL
  GROUP BY 1
)
SELECT
  ROUND(
    100.0 * SUM(CASE WHEN total_orders >= 2 THEN 1 ELSE 0 END)::numeric / COUNT(*),
    2
  ) AS repeat_customer_pct
FROM customer_orders;

-- 3) Top 15 product categories by revenue (English labels)
SELECT
  COALESCE(t.product_category_name_english, p.product_category_name) AS category,
  SUM(oi.price + oi.freight_value) AS revenue
FROM order_items oi
JOIN products p
  ON p.product_id = oi.product_id
LEFT JOIN category_translation t
  ON t.product_category_name = p.product_category_name
GROUP BY 1
ORDER BY revenue DESC
LIMIT 15;

-- 4) Payment type mix
SELECT
  payment_type,
  COUNT(*) AS payment_events,
  ROUND(SUM(payment_value), 2) AS total_value
FROM payments
GROUP BY 1
ORDER BY total_value DESC;

-- 5) Average number of items per order
SELECT
  ROUND(AVG(item_count), 2) AS avg_items_per_order
FROM (
  SELECT
    order_id,
    COUNT(*) AS item_count
  FROM order_items
  GROUP BY 1
) x;
