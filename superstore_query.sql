-- Regional & Segment FP&A Budget Variance

WITH segment_actuals AS (
    SELECT 
        region,
        segment,
        category,
        sub_category,
        COUNT(*) AS line_items,
        SUM(quantity) AS units_sold,
        ROUND(SUM(sales), 2) AS actual_sales,
        ROUND(SUM(profit), 2) AS actual_profit,
        ROUND(AVG(discount) * 100, 2) AS avg_discount_pct
    FROM orders
    GROUP BY region, segment, category, sub_category
),
budget_model AS (
    SELECT 
        *,
        -- Model a realistic FP&A Budget benchmark (105% of regional-subcategory segment average)
        ROUND(
            AVG(actual_sales) OVER (PARTITION BY region, sub_category) * 1.05,
            2
        ) AS budget_sales,
        -- Target Profit Budget based on a 15% benchmark gross margin
        ROUND(
            (AVG(actual_sales) OVER (PARTITION BY region, sub_category) * 1.05) * 0.15,
            2
        ) AS budget_profit
    FROM segment_actuals
)
SELECT 
    region,
    segment,
    category,
    sub_category,
    line_items,
    units_sold,
    actual_sales,
    budget_sales,
    ROUND(actual_sales - budget_sales, 2) AS sales_var_dollar,
    ROUND(((actual_sales - budget_sales) / NULLIF(budget_sales, 0)) * 100, 2) AS sales_var_pct,
    actual_profit,
    budget_profit,
    ROUND(actual_profit - budget_profit, 2) AS profit_var_dollar,
    ROUND((actual_profit / NULLIF(actual_sales, 0)) * 100, 2) AS gross_margin_pct,
    avg_discount_pct
FROM budget_model
ORDER BY region, segment, category, sub_category;

-- Discount Tier Margin Erosion Analysis

SELECT 
    category,
    CASE 
        WHEN discount = 0 THEN '0% (Full Price)'
        WHEN discount <= 0.15 THEN '1%–15% (Low)'
        WHEN discount <= 0.25 THEN '16%–25% (Standard)'
        WHEN discount <= 0.40 THEN '26%–40% (Heavy)'
        ELSE '40%+ (Deep Clearance)'
    END AS discount_tier,
    COUNT(*) AS line_items,
    SUM(quantity) AS units_sold,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / NULLIF(SUM(sales), 0)) * 100, 2) AS gross_margin_pct
FROM orders
GROUP BY 1, 2
ORDER BY category, MIN(discount);

-- Loss-Making Sub-Category & State Audit

SELECT 
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / NULLIF(SUM(sales), 0)) * 100, 2) AS gross_margin_pct,
    ROUND(AVG(discount) * 100, 2) AS avg_discount_pct
FROM orders
GROUP BY category, sub_category
ORDER BY total_profit ASC;