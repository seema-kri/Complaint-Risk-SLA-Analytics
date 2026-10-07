-- 1. Row count
SELECT COUNT(*) AS total_rows
FROM complaints;

-- 2. Duplicate ids
SELECT complaint_id, COUNT(*)
FROM complaints
GROUP BY complaint_id
HAVING COUNT(*) > 1;


-- 3. Nulls.
SELECT
    SUM(CASE WHEN channel IS NULL THEN 1 ELSE 0 END)         AS null_channel,
    SUM(CASE WHEN date_submitted IS NULL THEN 1 ELSE 0 END)  AS null_date,
    SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END)           AS null_state,
    SUM(CASE WHEN product IS NULL THEN 1 ELSE 0 END)         AS null_product,
    SUM(CASE WHEN issue IS NULL THEN 1 ELSE 0 END)           AS null_issue,
    SUM(CASE WHEN company_response IS NULL THEN 1 ELSE 0 END) AS null_response,
    SUM(CASE WHEN timely_response IS NULL THEN 1 ELSE 0 END) AS null_timely
FROM complaints;

-- 4. Date range
SELECT MIN(date_submitted) AS first_date,
       MAX(date_submitted) AS last_date
FROM complaints;


-- 5. Distinct counts
SELECT COUNT(DISTINCT state)            AS states,
       COUNT(DISTINCT product)          A
	   S products,
       COUNT(DISTINCT channel)          AS channels,
       COUNT(DISTINCT company_response) AS responses
FROM complaints;


-- 6. Flag totals
SELECT COUNT(*)                     AS total,
       SUM(is_in_progress)          AS in_progress,
       SUM(is_timely)               AS timely,
       SUM(is_late)                 AS late,
       SUM(has_monetary_relief)     AS monetary,
       SUM(has_non_monetary_relief) AS non_monetary
FROM complaints;

-- 7. Flags add up to total
SELECT complaint_id
FROM complaints
WHERE is_timely + is_late + is_in_progress <> 1;


-- 8. Relief flags consistent
SELECT complaint_id
FROM complaints
WHERE has_any_relief <> has_monetary_relief + has_non_monetary_relief;

-- 9. Date logic
SELECT complaint_id
FROM complaints
WHERE date_received < date_submitted;

-- 10. Intake lag.
SELECT MIN(intake_lag_days) AS min_lag,
       MAX(intake_lag_days) AS max_lag,
       SUM(CASE WHEN intake_lag_days > 30 THEN 1 ELSE 0 END) AS over_30
FROM complaints;

-- 11. Closed complaints and late rate.
SELECT COUNT(*) AS closed_complaints,
       ROUND(100.0 * SUM(is_late) / COUNT(*), 2) AS late_rate_pct
FROM complaints
WHERE is_in_progress = 0;