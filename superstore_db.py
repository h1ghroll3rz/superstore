import sqlite3
import pandas as pd

df = pd.read_csv("SampleSuperstore.csv")
df.columns = df.columns.str.strip().str.lower().str.replace(" ", "_").str.replace("-", "_")

print("Columns loaded:", list(df.columns))

conn = sqlite3.connect("superstore_fpa.db")
df.to_sql("orders", conn, if_exists="replace", index=False)
conn.close()
print(f"Loaded {len(df):,} rows into 'superstore_fpa.db' (table: orders).")

