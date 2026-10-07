-- Clean view for Power BI. Connect Power BI to this view, not the raw table.
CREATE OR REPLACE VIEW vw_complaints_bi AS
SELECT complaint_id,
       date_submitted,
       year,
       quarter,
       month,
       month_name,
       year_month,
       state,
       channel,
       product_short AS product,
       issue,
       sub_issue,
       company_response,
       timely_response,
       intake_lag_days,
       is_in_progress,
       is_timely,
       is_late,
       has_monetary_relief,
       has_any_relief
FROM complaints;

-- Check. Expected: 62516
SELECT COUNT(*) FROM vw_complaints_bi;