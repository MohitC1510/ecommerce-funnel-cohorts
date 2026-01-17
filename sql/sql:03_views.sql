-- ------------------------------------------------------------
-- 03_views.sql
-- Analytics views (order-level revenue + cohorts)
-- ------------------------------------------------------------

DROP VIEW IF EXISTS v_cohort_retention;
DROP VIEW IF EXISTS v_cohort_activity;
DROP VIEW IF EXISTS v_customer_first_purchase;
DROP VIEW IF EXISTS v_order_revenue;

-- Order-level revenue (1 row per order)
CREATE VIEW v_order_revenue AS
SELECT
  o.order_id,
  o.customer_id,
  c.customer_unique_id,
  o.order_status,
  o.order_purchase_timestamp,
  DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
  SUM(oi.price + oi.freight_value) AS gross_revenue
FROM orders o
JOIN customers c
  ON c.customer_id = o.customer_id
JOIN order_items oi
  ON oi.order_id = o.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
GROUP BY 1,2,3,4,5,6;

-- Assign each unique customer to a cohort (their first purchase month)
CREATE VIEW v_customer_first_purchase AS
SELECT
  c.customer_unique_id,
  MIN(o.order_purchase_timestamp) AS first_purchase_ts,
  DATE_TRUNC('month', MIN(o.order_purchase_timestamp)) AS cohort_month
FROM customers c
JOIN orders o
  ON o.customer_id = c.customer_id
WHERE o.order_purchase_timestamp IS NOT NULL
GROUP BY 1;

-- Active customers per cohort-month and activity-month
CREATE VIEW v_cohort_activity AS
SELECT
  fp.cohort_month,
  DATE_TRUNC('month', o.order_purchase_timestamp) AS active_month,
  COUNT(DISTINCT c.customer_unique_id) AS active_customers
FROM orders o
JOIN customers c
  ON c.customer_id = o.customer_id
JOIN v_customer_first_purchase fp
  ON fp.customer_unique_id = c.customer_unique_id
WHERE o.order_purchase_timestamp IS NOT NULL
GROUP BY 1,2;

-- Retention base (month_number = months since first purchase)
CREATE VIEW v_cohort_retention AS
SELECT
  cohort_month,
  active_month,
  (
    (DATE_PART('year', active_month) * 12 + DATE_PART('month', active_month)) -
    (DATE_PART('year', cohort_month) * 12 + DATE_PART('month', cohort_month))
  )::INT AS month_number,
  active_customers
FROM v_cohort_activity
WHERE active_month >= cohort_month;
