import pandas as pd

base_path = "data/"

# Load data
customers = pd.read_csv(base_path + "customers.csv")
products = pd.read_csv(base_path + "products.csv")
orders = pd.read_csv(base_path + "orders.csv")
order_items = pd.read_csv(base_path + "order_items.csv")

def clean_orders(df):

    df['order_date'] = pd.to_datetime(df['order_date'], errors='coerce')

    df['customer_id'] = df['customer_id'].replace('', None)
    df['customer_id'] = df['customer_id'].fillna("UNKNOWN")

    return df


orders_clean = clean_orders(orders)

def clean_products(df):

    df['product_name'] = df['product_name'].str.strip()
    df['product_name'] = df['product_name'].str.title()

    return df


products_clean = clean_products(products)

def validate_emails(df):

    invalid = df[
        ~df['email'].str.contains(r'^[^@]+@[^@]+\.[^@]+$', na=False)
    ]

    return invalid


invalid_emails = validate_emails(customers)

def check_referential_integrity(order_items, orders):

    order_items['order_id'] = order_items['order_id'].astype(str).str.strip()
    orders['order_id'] = orders['order_id'].astype(str).str.strip()

    invalid = order_items[
        ~order_items['order_id'].isin(orders['order_id'])
    ]

    return invalid


invalid_orders = check_referential_integrity(order_items, orders)

def clean_order_items(df):

    df['is_return'] = df['quantity'] < 0

    df = df[df['quantity'] != 0]

    return df


order_items_clean = clean_order_items(order_items)

def fix_discount(df):

    df['discount_percent'] = df['discount_percent'].clip(0, 100)

    return df


order_items_clean = fix_discount(order_items_clean)

customers.to_csv(base_path + "clean_customers.csv", index=False)
products_clean.to_csv(base_path + "clean_products.csv", index=False)
orders_clean.to_csv(base_path + "clean_orders.csv", index=False)
order_items_clean.to_csv(base_path + "clean_order_items.csv", index=False)

print("DATA QUALITY REPORT")

print("Invalid Emails:", len(invalid_emails))
print("Invalid Order References:", len(invalid_orders))
print("Negative Quantity:", (order_items['quantity'] < 0).sum())
print("Zero Quantity:", (order_items['quantity'] == 0).sum())
print("Invalid Discount:", (order_items['discount_percent'] > 100).sum())

