-- 1. Rank products by late rate (CTE + DENSE_RANK)

WITH product_sla AS (
    SELECT product_short,
           COUNT(*) AS closed_complaints,
           ROUND(100.0 * SUM(is_late) / COUNT(*), 2) AS late_rate_pct
    FROM complaints
    WHERE is_in_progress = 0
    GROUP BY product_short
)
SELECT product_short,
       closed_complaints,
       late_rate_pct,
       DENSE_RANK() OVER (ORDER BY late_rate_pct DESC) AS risk_rank
FROM product_sla
ORDER BY risk_rank;

-- 2. Monthly volume, previous month, 3-month rolling average (LAG + AVG OVER)
WITH monthly AS (
    SELECT year_month, COUNT(*) AS complaints
    FROM complaints
    GROUP BY year_month
)
SELECT year_month,
       complaints,
       LAG(complaints) OVER (ORDER BY year_month) AS prev_month,
       ROUND(AVG(complaints) OVER (ORDER BY year_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS rolling_3m_avg
FROM monthly
ORDER BY year_month;

-- 3. Late rate by product and year, small products excluded
SELECT product_short, year,
       COUNT(*) AS closed_complaints,
       ROUND(100.0 * SUM(is_late) / COUNT(*), 2) AS late_rate_pct
FROM complaints
WHERE is_in_progress = 0
  AND product_short NOT IN ('Student Loan', 'Payday/Personal Loan')
GROUP BY product_short, year
ORDER BY product_short, year;