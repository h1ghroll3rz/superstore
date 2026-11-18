# Commercial FP&A Performance — Revenue, Margin & Discount Erosion Audit

End-to-end Financial Planning & Analysis (FP&A) evaluation of **9,994 retail transactions** (**$2.30M** revenue; **$286.4K** gross profit) using **SQL (SQLite)**, **Python (`sqlite3`, `pandas`)**, and **Power BI** to benchmark regional budget variance, audit product-line profitability, and quantify margin erosion from discounting.

![Commercial FP&A Dashboard](fpa_dashboard.png)

## 1. Business Problem
High top-line sales can mask severe margin leakage when aggressive discounting goes unmonitored. This project simulates a commercial FP&A review across four US regions and three customer segments (`Consumer`, `Corporate`, `Home Office`) to answer three core questions:
1. How is actual revenue performing against regional segment budget benchmarks, and where are gross margins lagging?
2. Which product sub-categories generate strong revenue while eroding bottom-line profit?
3. At what discount threshold does transaction gross margin flip negative, and how much profit can be recovered through pricing guardrails?

## 2. Methodology
* **Relational Database & ETL (`Python — sqlite3, pandas`):** Automated CSV schema standardisation and ingestion into a local SQLite database (`load_db.py`), plus automated multi-query CSV extraction (`export_pbi.py`) to feed the BI layer.
* **Analytical SQL (`SQLite — fpa_analysis.sql`):**
  * **Budget Variance Modelling:** Used Common Table Expressions (`CTEs`) and window functions (`AVG() OVER (PARTITION BY region, sub_category)`) to benchmark segment performance against territory-adjusted budget targets (`105%` of regional segment average).
  * **Discount Tier Bucketing:** Engineered five pricing tiers (`0% Full Price` through `40%+ Deep Clearance`) via `CASE WHEN` statements to isolate margin compression.
  * **Defensive Aggregation:** Implemented `NULLIF` division guards and positional grouping to ensure production-safe ratio calculations.
* **Executive Dashboarding (`Power BI, DAX, Power Query`):** Built an interactive 4-quadrant FP&A report featuring dynamic `DAX` measures (`Actual Revenue`, `Revenue Variance %`, `Gross Margin %`), `Power Query` custom tier sorting, conditional red/blue profitability rules, and cross-filtering `Region` and `Customer Segment` slicers.

## 3. Executive Financial Summary

| Metric / Diagnostic Area | Performance | FP&A Insight |
| :--- | :---: | :--- |
| **Total Actual Revenue** | **$2.30M** | `-4.8%` variance against modelled regional segment stretch budget |
| **Total Gross Profit & Margin** | **$286.4K (`12.5%`)** | `Consumer` leads volume, while `Central` region trails on gross margin |
| **Top Loss-Making Line (`Tables`)** | **-$17.7K (`-8.6%` margin)** | Generated `$206K` in sales but bled profit due to a `26.1%` average discount |
| **Secondary Margin Drain (`Bookcases`)** | **-$3.5K** | Persistent negative margin driven by heavy Furniture discounting |
| **Discount Erosion Threshold** | **> 20% Discount Cliff** | Orders in the `26%–40%` and `40%+` tiers destroyed **$100K+** in combined profit |

## 4. Commercial Recommendations
* **Enforce a 15%–20% Discount Approval Guardrail:** Transactions discounted at `0%–15%` maintain healthy positive margins across all categories, whereas discounts above `20%` trigger steep losses. Requiring manager sign-off above `20%` on Furniture is projected to recover **$21K+** in annual bottom-line profit.
* **Reprice or Restructure `Tables` & `Bookcases`:** Audit supplier costs and bundle pricing on loss-making Furniture sub-categories rather than relying on deep promotional markdowns to drive volume.

## 5. Repository Structure & Data Source
* `load_db.py` — Python ETL script loading `SampleSuperstore.csv` into `superstore_fpa.db`.
* `fpa_analysis.sql` — Multi-query SQL script for budget variance, discount tier erosion, and sub-category profitability audits.
* `export_pbi.py` — Script executing `fpa_analysis.sql` and exporting clean tables for Power BI.
* `fpa_dashboard.pbix` — Interactive Power BI Desktop report file.
* `fpa_dashboard.png` — High-resolution export of the final dashboard.
* **Dataset:** [Sample Superstore Dataset (Kaggle)](https://www.kaggle.com/datasets/bravehart101/sample-superstore-dataset)
