-- ------------------------------------------------------------
-- 01_schema.sql
-- Base tables for Olist ecommerce analytics project (Postgres)
-- ------------------------------------------------------------

-- Drop in dependency order
DROP TABLE IF EXISTS category_translation CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

-- Customers
CREATE TABLE customers (
  customer_id TEXT PRIMARY KEY,
  customer_unique_id TEXT,
  customer_zip_code_prefix INT,
  customer_city TEXT,
  customer_state TEXT
);

-- Orders
CREATE TABLE orders (
  order_id TEXT PRIMARY KEY,
  customer_id TEXT REFERENCES customers(customer_id),
  order_status TEXT,
  order_purchase_timestamp TIMESTAMP,
  order_approved_at TIMESTAMP,
  order_delivered_carrier_date TIMESTAMP,
  order_delivered_customer_date TIMESTAMP,
  order_estimated_delivery_date TIMESTAMP
);

-- Order items (line items)
CREATE TABLE order_items (
  order_id TEXT REFERENCES orders(order_id),
  order_item_id INT,
  product_id TEXT,
  seller_id TEXT,
  shipping_limit_date TIMESTAMP,
  price NUMERIC,
  freight_value NUMERIC,
  PRIMARY KEY (order_id, order_item_id)
);

-- Payments
CREATE TABLE payments (
  order_id TEXT REFERENCES orders(order_id),
  payment_sequential INT,
  payment_type TEXT,
  payment_installments INT,
  payment_value NUMERIC,
  PRIMARY KEY (order_id, payment_sequential)
);

-- Products
-- Note: Olist column spelling is "product_name_lenght" (yes, it's misspelled in dataset)
CREATE TABLE products (
  product_id TEXT PRIMARY KEY,
  product_category_name TEXT,
  product_name_lenght INT,
  product_description_lenght INT,
  product_photos_qty INT,
  product_weight_g INT,
  product_length_cm INT,
  product_height_cm INT,
  product_width_cm INT
);

-- Category translation (Portuguese -> English)
CREATE TABLE category_translation (
  product_category_name TEXT PRIMARY KEY,
  product_category_name_english TEXT
);

-- Helpful indexes (speed up joins)
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_payments_order_id ON payments(order_id);
CREATE INDEX IF NOT EXISTS idx_customers_unique_id ON customers(customer_unique_id);
