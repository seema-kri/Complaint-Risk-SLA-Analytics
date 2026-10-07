-- 1. Headline KPIs, closed complaints only
SELECT COUNT(*) AS closed_complaints,
       ROUND(100.0 * SUM(is_timely) / COUNT(*), 2)           AS timely_rate_pct,
       ROUND(100.0 * SUM(is_late) / COUNT(*), 2)             AS late_rate_pct,
       ROUND(100.0 * SUM(has_any_relief) / COUNT(*), 2)      AS any_relief_pct,
       ROUND(100.0 * SUM(has_monetary_relief) / COUNT(*), 2) AS monetary_relief_pct
FROM complaints
WHERE is_in_progress = 0;

-- 2. Complaints by product with share
SELECT product_short,
       COUNT(*) AS complaints,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS share_pct
FROM complaints
GROUP BY product_short
ORDER BY complaints DESC;

-- 3. Top 10 issues
SELECT issue, COUNT(*) AS complaints
FROM complaints
GROUP BY issue
ORDER BY complaints DESC
LIMIT 10;

-- 4. Late rate by product
SELECT product_short,
       COUNT(*) AS closed_complaints,
       SUM(is_late) AS late,
       ROUND(100.0 * SUM(is_late) / COUNT(*), 2) AS late_rate_pct
FROM complaints
WHERE is_in_progress = 0
GROUP BY product_short
ORDER BY late_rate_pct DESC;


-- 5. Late rate by year
SELECT year,
       COUNT(*) AS closed_complaints,
       SUM(is_late) AS late,
       ROUND(100.0 * SUM(is_late) / COUNT(*), 2) AS late_rate_pct
FROM complaints
WHERE is_in_progress = 0
GROUP BY year
ORDER BY year;

