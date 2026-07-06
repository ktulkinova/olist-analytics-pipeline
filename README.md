# Olist E-commerce: PostgreSQL Analytics Pipeline

End-to-end pipeline on the Brazilian Olist dataset (100k orders, 2016–2018). CSV → Python ETL → PostgreSQL → SQL analytics.

<img width="1414" height="1262" alt="erd" src="https://github.com/user-attachments/assets/bf473a36-d6d4-4542-befe-80767381708c" />


## Stack
- Python (pandas, SQLAlchemy) — ETL
- PostgreSQL — database
- SQL — schema, analytics, views, indexes
- Make — pipeline runner

## What the project shows
- Database schema design (9 tables, relations, keys)
- ETL: read CSV, clean data, load into Postgres
- SQL analytics: joins, subqueries, window functions, RFM customer segmentation
- Optimization: views, materialized view, indexes

## Key findings

| Area | Insight |
|---|---|
| Sales | Revenue grew 10x in 2017. Peak in November (Black Friday) |
| Customers | Only 3.1% of customers come back — weak retention |
| Delivery | 8% of orders are late. Late delivery drops review score from 4.3 to 2.6 |
| Payments | Installments double the average order value (96 → 197 R$) |
| Geography | SP state = 42% of customers and sellers, concentration risk |

## Project structure

    etl/          — Python ETL script
    sql/ddl/      — CREATE TABLE
    sql/analytics — 5 SQL analysis blocks
    sql/views/    — views + indexes
    docs/erd.png  — schema diagram
    Makefile      — pipeline commands

## How to run

    make db-create
    make schema
    make load
    make views
    make analytics

Or all at once: `make all`.

## Data cleaning
- Removed 261k duplicate rows in geolocation
- Removed 814 duplicate reviews
- Handled NULL values in product categories

## Design note
Dropped the FK from `products.product_category_name` to the translation table. The translation table does not cover all categories in the raw data.

## Orchestration (Airflow + Docker)
Airflow runs in Docker. A DAG `olist_etl` schedules the pipeline:
- `truncate_tables` — clears all tables
- `check_count` — verifies row count in orders

Schedule: `@daily`. See `airflow/dags/olist_etl_dag.py`.

<img width="1280" height="828" alt="airflow_dag" src="https://github.com/user-attachments/assets/a550de66-cefc-4206-a7e5-47de626074fc" />



