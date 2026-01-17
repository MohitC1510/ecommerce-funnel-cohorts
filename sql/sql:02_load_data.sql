-- ------------------------------------------------------------
-- 02_load_data.sql
-- Load CSVs into Postgres using \copy (psql only)
-- ------------------------------------------------------------

-- If you're not already connected:
-- \c ecommerce_analytics

-- These paths assume you run psql from your repo root:
-- ecommerce-funnel-cohorts/

\copy customers FROM 'data/raw/olist_customers_dataset.csv' WITH (FORMAT csv, HEADER true);
\copy orders FROM 'data/raw/olist_orders_dataset.csv' WITH (FORMAT csv, HEADER true);
\copy order_items FROM 'data/raw/olist_order_items_dataset.csv' WITH (FORMAT csv, HEADER true);
\copy payments FROM 'data/raw/olist_order_payments_dataset.csv' WITH (FORMAT csv, HEADER true);
\copy products FROM 'data/raw/olist_products_dataset.csv' WITH (FORMAT csv, HEADER true);

\copy category_translation FROM 'data/raw/product_category_name_translation.csv' WITH (FORMAT csv, HEADER true);

-- Quick row count check
SELECT 'customers' AS table, COUNT(*) FROM customers
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'payments', COUNT(*) FROM payments
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'category_translation', COUNT(*) FROM category_translation;
