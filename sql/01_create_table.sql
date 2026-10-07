CREATE DATABASE complaint_analytics;

CREATE TABLE complaints (
    complaint_id             INTEGER PRIMARY KEY,
    channel                  VARCHAR(30),
    date_submitted           DATE,
    date_received            DATE,
    state                    CHAR(2),
    product                  TEXT,
    sub_product              TEXT,
    issue                    TEXT,
    sub_issue                TEXT,
    company_public_response  TEXT,
    company_response         VARCHAR(50),
    timely_response          VARCHAR(5),
    year                     SMALLINT,
    quarter                  SMALLINT,
    month                    SMALLINT,
    month_name               VARCHAR(3),
    year_month               VARCHAR(7),
    intake_lag_days          SMALLINT,
    is_in_progress           SMALLINT,
    is_timely                SMALLINT,
    is_late                  SMALLINT,
    has_monetary_relief      SMALLINT,
    has_non_monetary_relief  SMALLINT,
    has_any_relief           SMALLINT,
    product_short            VARCHAR(30)
);

