import pandas as pd
from sqlalchemy import create_engine

engine = create_engine("postgresql://kamola@localhost:5432/olist")

files = {
    "customers": "data/raw/olist_customers_dataset.csv",
    "sellers": "data/raw/olist_sellers_dataset.csv",
    "product_category_name_translation": "data/raw/product_category_name_translation.csv",
    "products": "data/raw/olist_products_dataset.csv",
    "geolocation": "data/raw/olist_geolocation_dataset.csv",
    "orders": "data/raw/olist_orders_dataset.csv",
    "order_items": "data/raw/olist_order_items_dataset.csv",
    "order_payments": "data/raw/olist_order_payments_dataset.csv",
    "order_reviews": "data/raw/olist_order_reviews_dataset.csv",
}


def clean(table, df):
    df = df.drop_duplicates()

    if table == "products":
        df["product_category_name"] = df["product_category_name"].where(
            df["product_category_name"].notna(), None
        )

    if table == "order_reviews":
        df = df.drop_duplicates(subset=["review_id"])

    return df


for table, path in files.items():
    df = pd.read_csv(path)
    before = len(df)
    df = clean(table, df)
    after = len(df)
    df.to_sql(table, engine, if_exists="append", index=False)
    print(f"{table}: {after} rows loaded ({before - after} cleaned)")