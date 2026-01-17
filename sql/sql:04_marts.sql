-- ------------------------------------------------------------
-- 04_marts.sql
-- Materialized views (dashboard-ready marts)
-- ------------------------------------------------------------

DROP MATERIALIZED VIEW IF EXISTS mart_monthly_kpis;
CREATE MATERIALIZED VIEW mart_monthly_kpis AS
SELECT
  order_month::date AS month,
  COUNT(DISTINCT order_id) AS orders,
  COUNT(DISTINCT customer_unique_id) AS unique_customers,
  ROUND(SUM(gross_revenue), 2) AS revenue,
  ROUND(AVG(gross_revenue), 2) AS aov,
  ROUND(
    1.0 * COUNT(DISTINCT order_id) / NULLIF(COUNT(DISTINCT customer_unique_id), 0),
    2
  ) AS orders_per_customer
FROM v_order_revenue
GROUP BY 1
ORDER BY 1;

-- Helpful unique index (enables CONCURRENT refresh if needed later)
CREATE UNIQUE INDEX IF NOT EXISTS ux_mart_monthly_kpis_month
ON mart_monthly_kpis(month);

-- Cohort retention mart
DROP MATERIALIZED VIEW IF EXISTS mart_cohort_retention;
CREATE MATERIALIZED VIEW mart_cohort_retention AS
WITH cohort_sizes AS (
  SELECT
    cohort_month,
    MAX(active_customers) AS cohort_size
  FROM v_cohort_retention
  WHERE month_number = 0
  GROUP BY 1
)
SELECT
  r.cohort_month::date AS cohort_month,
  r.month_number,
  r.active_customers,
  cs.cohort_size,
  ROUND(
    100.0 * r.active_customers::numeric / NULLIF(cs.cohort_size, 0),
    2
  ) AS retention_pct
FROM v_cohort_retention r
JOIN cohort_sizes cs
  USING (cohort_month)
ORDER BY 1,2;

CREATE UNIQUE INDEX IF NOT EXISTS ux_mart_cohort_retention_key
ON mart_cohort_retention(cohort_month, month_number);

-- Manual refresh commands
-- REFRESH MATERIALIZED VIEW mart_monthly_kpis;
-- REFRESH MATERIALIZED VIEW mart_cohort_retention;
