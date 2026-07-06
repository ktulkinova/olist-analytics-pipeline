from airflow import DAG
from airflow.decorators import task
from airflow.providers.postgres.hooks.postgres import PostgresHook
from datetime import datetime


@task
def truncate_tables():
    hook = PostgresHook(postgres_conn_id="olist_db")
    hook.run("TRUNCATE customers, sellers, product_category_name_translation, products, geolocation, orders, order_items, order_payments, order_reviews CASCADE;")


@task
def check_count():
    hook = PostgresHook(postgres_conn_id="olist_db")
    result = hook.get_first("SELECT COUNT(*) FROM orders;")
    print(f"Orders count: {result[0]}")


with DAG(
    dag_id="olist_etl",
    start_date=datetime(2026, 1, 1),
    schedule="@daily",
    catchup=False,
    tags=["olist", "etl", "portfolio"],
) as dag:
    truncate_tables() >> check_count()