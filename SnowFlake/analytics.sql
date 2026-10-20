CREATE WAREHOUSE IF NOT EXISTS WH_XS WAREHOUSE_SIZE='XSMALL' AUTO_SUSPEND=60 AUTO_RESUME=TRUE;
CREATE DATABASE IF NOT EXISTS OLIST;
CREATE SCHEMA IF NOT EXISTS OLIST.GOLD;
USE WAREHOUSE WH_XS;
USE SCHEMA OLIST.GOLD;
CREATE OR REPLACE TABLE dim_customer (customer_id STRING, customer_unique_id STRING, customer_city STRING, customer_state STRING);
CREATE OR REPLACE TABLE dim_product (product_id STRING, category STRING, product_weight_g FLOAT, product_length_cm FLOAT, product_height_cm FLOAT, product_width_cm FLOAT);
CREATE OR REPLACE TABLE dim_seller (seller_id STRING, seller_city STRING, seller_state STRING);
CREATE OR REPLACE TABLE dim_date (date DATE, date_key INT, year INT, month INT, month_name STRING, quarter INT, day_of_week STRING);
CREATE OR REPLACE TABLE fact_order_items (order_id STRING, order_item_id INT, customer_id STRING, product_id STRING, seller_id STRING, date_key INT, order_status STRING, price FLOAT, freight_value FLOAT, item_total FLOAT, delivery_days INT, days_vs_estimate INT, is_late BOOLEAN);
CREATE OR REPLACE TABLE fact_payments (order_id STRING, payment_sequential INT, payment_type STRING, payment_installments INT, payment_value FLOAT);


-- loading data from s3 
CREATE OR REPLACE FILE FORMAT csv_fmt TYPE=CSV SKIP_HEADER=1 FIELD_OPTIONALLY_ENCLOSED_BY='"' NULL_IF=('','NaN','nan');

CREATE OR REPLACE STAGE gold_stage
  URL='s3://diksha-olist-lakehouse/gold/'
  CREDENTIALS=(AWS_KEY_ID='' AWS_SECRET_KEY='')
  FILE_FORMAT=csv_fmt;

COPY INTO dim_customer FROM @gold_stage/dim_customer/;
COPY INTO dim_product FROM @gold_stage/dim_product/;
COPY INTO dim_seller FROM @gold_stage/dim_seller/;
COPY INTO dim_date FROM @gold_stage/dim_date/;
COPY INTO fact_order_items FROM @gold_stage/fact_order_items/;
COPY INTO fact_payments FROM @gold_stage/fact_payments/;


-- Analytics
-- Monthly revenue and orders
SELECT d.year, d.month, SUM(f.item_total) AS revenue, COUNT(DISTINCT f.order_id) AS orders
FROM fact_order_items f JOIN dim_date d ON f.date_key = d.date_key
WHERE f.order_status = 'delivered'
GROUP BY 1,2 ORDER BY 1,2;

-- Top 10 categories by revenue
SELECT p.category, ROUND(SUM(f.price),0) AS revenue, COUNT(*) AS items_sold
FROM fact_order_items f JOIN dim_product p ON f.product_id = p.product_id
GROUP BY 1 ORDER BY revenue DESC LIMIT 10;

-- Average order value
SELECT ROUND(SUM(item_total)/COUNT(DISTINCT order_id),2) AS aov FROM fact_order_items;

-- Late delivery rate by customer state
SELECT c.customer_state,
       ROUND(100*AVG(IFF(f.is_late,1,0)),1) AS late_pct,
       ROUND(AVG(f.delivery_days),1) AS avg_delivery_days
FROM fact_order_items f JOIN dim_customer c ON f.customer_id = c.customer_id
WHERE f.order_status='delivered'
GROUP BY 1 ORDER BY late_pct DESC;

-- Payment type mix
SELECT payment_type, COUNT(*) AS payments, ROUND(SUM(payment_value),0) AS value
FROM fact_payments GROUP BY 1 ORDER BY value DESC;

-- Top sellers with running rank
SELECT seller_id, ROUND(SUM(price),0) AS revenue,
       RANK() OVER (ORDER BY SUM(price) DESC) AS rnk
FROM fact_order_items GROUP BY seller_id QUALIFY rnk <= 10;
