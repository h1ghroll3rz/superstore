import sqlite3
import pandas as pd

conn = sqlite3.connect("superstore_fpa.db")
with open("superstore.sql", "r") as f:
    queries = [q.strip() for q in f.read().split(";") if q.strip()]

pd.read_sql_query(queries[0], conn).to_csv("fpa_segment_performance.csv", index=False)
pd.read_sql_query(queries[1], conn).to_csv("fpa_discount_erosion.csv", index=False)
pd.read_sql_query(queries[2], conn).to_csv("fpa_subcategory_audit.csv", index=False)
conn.close()
print("Exported all 3 SQL queries to CSV.")