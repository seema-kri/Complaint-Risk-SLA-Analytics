-- Why did July 2023 spike to 1,749 complaints?

-- 1. Monthly volume in 2023
SELECT year_month, COUNT(*) AS complaints
FROM complaints
WHERE year_month >= '2023-01'
GROUP BY year_month
ORDER BY year_month;

-- 2. Which days caused the spike?
SELECT date_submitted, COUNT(*) AS complaints
FROM complaints
WHERE date_submitted >= '2023-07-01'
GROUP BY date_submitted
ORDER BY complaints DESC
LIMIT 5;

-- 3. Which products drove July?
SELECT product_short, COUNT(*) AS complaints
FROM complaints
WHERE year_month = '2023-07'
GROUP BY product_short
ORDER BY complaints DESC;