# olist-lakehouse
End-to-end e-commerce data lakehouse using AWS S3, Databricks, PySpark, Delta Lake, Snowflake, SQL, and data quality checks.
# E-commerce Data Lakehouse

## About the Project

I am building an end-to-end data lakehouse project using the Olist Brazilian E-commerce dataset. My goal is to understand how raw data can be transformed into clean, reliable, and useful information for business analysis.

The dataset contains approximately 100,000 orders across nine related tables, including customers, orders, products, payments, sellers, and reviews.

Through this project, I am exploring how data engineers ingest data, clean and transform it, validate its quality, store it efficiently, and prepare it for analytical reporting.

## Project Objectives

My main objectives are to:

- Ingest raw CSV files and convert them into Parquet format.
- Store the data in Amazon S3.
- Implement the Bronze, Silver, and Gold layers using Databricks, PySpark, and Delta Lake.
- Apply data quality checks for missing values, duplicate records, schema validation, and referential integrity.
- Design a star schema for analytical queries.
- Load curated data into Snowflake and analyze it using SQL.
- Build a Power BI dashboard to visualize business metrics.
- Explore workflow orchestration using Apache Airflow and AWS-native analytics using Glue and Athena.

## Technologies Used

| Technology | Purpose |
|---|---|
| Python | Data ingestion and processing |
| boto3 | Interacting with Amazon S3 |
| AWS S3 | Storing raw and processed data |
| Databricks | Data transformation |
| PySpark | Processing and cleaning data |
| Delta Lake | Managing data in the Medallion architecture |
| Snowflake | Data warehousing and analytical SQL |
| Power BI | Business intelligence and visualization |
| Apache Airflow | Workflow orchestration |
| AWS Glue and Athena | Data cataloging and querying data in S3 |

*The technologies and components listed here reflect the project plan. I will update this section as I implement and test each component.*

## Architecture

The planned data flow is:

1. **Data Source:** Download the public Olist e-commerce dataset.
2. **Ingestion:** Use Python and boto3 to upload the raw files to Amazon S3 and convert CSV files to Parquet.
3. **Bronze Layer:** Store the ingested data with basic ingestion metadata.
4. **Silver Layer:** Clean the data, remove duplicates, standardize values, convert data types, and validate relationships.
5. **Gold Layer:** Create analytical fact and dimension tables using a star schema.
6. **Data Warehouse:** Load the curated tables into Snowflake.
7. **Analytics:** Write SQL queries to analyze revenue, order trends, product categories, payments, and delivery performance.
8. **Visualization:** Build a Power BI dashboard to present the results.

I also plan to explore Airflow for orchestration and AWS Glue and Athena for querying data stored in S3.

## Data Quality

An important part of this project is making sure that the data is reliable before using it for analysis.

I am implementing checks for:

- Row counts and expected columns.
- Null values in important fields.
- Duplicate primary keys.
- Referential integrity between related tables.
- Data types and standardized values.

The objective is to identify data quality issues early and prevent invalid data from moving into the analytical layer.

## Business Questions

The curated data will help answer questions such as:

- How does revenue change over time?
- Which product categories generate the most revenue?
- What is the average order value?
- How long do deliveries take?
- Which customer states experience more late deliveries?
- Which payment methods are most commonly used?
- Which sellers generate the highest revenue?

## Repository Structure

```text
olist-lakehouse/
├── README.md
├── ingest.py
├── databricks/
├── sql/
│   └── analytics.sql
├── airflow/
│   └── dags/
│       └── olist_pipeline.py
├── docs/
│   └── screenshots/
└── .gitignore
```

The repository will contain the ingestion code, Databricks notebooks, SQL queries, orchestration code where implemented, and screenshots of the actual results.

## Dataset

The project uses the publicly available Olist Brazilian E-Commerce dataset.

Dataset source: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

The dataset contains multiple related tables covering orders, customers, products, sellers, payments, reviews, and geolocation.

## Current Status

I am developing this project step by step, starting with data ingestion and storage, followed by data transformation, quality validation, and analytical reporting.

I will update this README with implementation details, screenshots, and verified results as the project progresses.

## What I Learned

Through this project, I aim to strengthen my practical understanding of data engineering concepts, including data ingestion, file formats, data quality, Medallion architecture, dimensional modeling, cloud storage, data warehousing, and analytical SQL.

