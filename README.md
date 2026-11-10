# E-commerce Data Lakehouse (Olist)

An end-to-end data lakehouse built on the public Olist Brazilian e-commerce dataset (~100,000 orders across 9 related tables). Raw CSV files are ingested to Amazon S3, cleaned and modelled through a Bronze/Silver/Gold Medallion architecture in Databricks with PySpark and Delta Lake, validated with data quality checks, and loaded into Snowflake as a star schema for analytical SQL.

## Architecture

```
Kaggle CSVs
   │  ingest.py (Python, pandas, boto3)
   ▼
Amazon S3  ── raw/csv, raw/parquet
   │
   ▼
Databricks (PySpark + Delta Lake)
   Bronze  → raw tables + ingestion metadata
   Silver  → cleaned, deduplicated, typed, validated
   Gold    → star schema (facts + dimensions) written back to S3
   │
   ▼
Snowflake  ── COPY INTO from S3 stage → analytical SQL
```

## What's in this repo

| Path | What it does |
| --- | --- |
| `ingest.py` | Uploads raw CSVs to S3, converts each table to Parquet, and uploads one folder per table |
| `databricks/Bronze.ipynb` | Loads raw data into Bronze Delta tables |
| `databricks/Silver.ipynb` | Cleans data: nulls, duplicates, type casting, standardised values, data quality checks |
| `databricks/Gold.ipynb` | Builds the star schema: `fact_order_items`, `fact_payments`, `dim_customer`, `dim_product`, `dim_seller`, `dim_date` |
| `SnowFlake/analytics.sql` | Creates the Snowflake warehouse and tables, loads Gold data from S3, and runs the analytics queries |
| `SnowFlake/results/` | Exported results of each query |

## Data quality checks

Data moves to the next layer only after passing checks for:

- Row counts and expected columns
- Nulls in key fields
- Duplicate primary keys
- Referential integrity between related tables (e.g. every order item maps to a valid order, product and seller)
- Data types and standardised values

## Data model (Gold layer)

- **Facts:** `fact_order_items` (price, freight, item total, delivery days, days vs estimate, late flag), `fact_payments`
- **Dimensions:** `dim_customer`, `dim_product`, `dim_seller`, `dim_date`

## Results (Snowflake)

| Question | Result |
| --- | --- |
| Average order value | **160.58 BRL** |
| Top revenue category | **health_beauty** (~1.26M BRL, 9,670 items), then watches_gifts and bed_bath_table |
| Highest late-delivery rate by state | **AL – 24.1% late**, avg 24.4 delivery days |
| Lowest late-delivery rate (large market) | **SP – 5.8% late**, avg 8.7 delivery days |

Other queries: monthly revenue and orders, payment type mix, and top 10 sellers by revenue using a window-function rank. See `SnowFlake/results/`.

## Tech stack

Python · pandas · boto3 · Amazon S3 · Databricks · PySpark · Delta Lake · Snowflake · SQL

## Next steps

- Orchestrate the pipeline with an Apache Airflow DAG
- Query the S3 data with AWS Glue and Athena
- Build a Power BI dashboard on the Gold tables

## Dataset

[Olist Brazilian E-Commerce dataset (Kaggle)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
