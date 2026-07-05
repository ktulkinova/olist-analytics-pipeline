.PHONY: db-create db-drop schema load truncate analytics views all clean

db-create:
	createdb olist

db-drop:
	dropdb --if-exists olist

schema:
	psql -d olist -f sql/ddl/01_create_tables.sql

load:
	python etl/load_csv.py

truncate:
	psql -d olist -c "TRUNCATE customers, sellers, product_category_name_translation, products, geolocation, orders, order_items, order_payments, order_reviews CASCADE;"

analytics:
	psql -d olist -f sql/analytics/sales.sql
	psql -d olist -f sql/analytics/customers.sql
	psql -d olist -f sql/analytics/delivery.sql
	psql -d olist -f sql/analytics/sellers.sql
	psql -d olist -f sql/analytics/payments.sql

views:
	psql -d olist -f sql/views/views.sql

all: db-create schema load views analytics

clean: db-drop
