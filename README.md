# Complaint Risk & SLA Analytics

> Finding where consumer complaint risk is concentrated and whether response deadlines (SLA) are being met, using Python, PostgreSQL, and Power BI.

![Executive Overview](dashboard/Executive%20Overview.png)

## Table of Contents

1. [Overview](#overview)
2. [Business Problem](#business-problem)
3. [Dataset Description](#dataset-description)
4. [Tools & Technologies](#tools--technologies)
5. [Project Structure](#project-structure)
6. [Data Cleaning & Preparation](#data-cleaning--preparation)
7. [EDA & Key Insights](#eda--key-insights)
8. [Dashboard](#dashboard)
9. [How to Run This Project](#how-to-run-this-project)
10. [Final Recommendations & Future Work](#final-recommendations--future-work)
11. [Author & Contact](#author--contact)

## Overview

This project analyzes **62,516 public CFPB consumer complaints** (May 2017 to Aug 2023) for a retail financial institution. The data is cleaned in Python, validated and queried in PostgreSQL, and presented in a 3 page Power BI report.

The headline late response rate is a healthy **3.94%**. The project shows that this one number hides real problems in individual products and years, then turns the findings into six ranked business decisions.

**Scope:** data cleaning, SQL validation and KPIs, root cause analysis, SLA monitoring, a Power BI dashboard, and an action plan.

## Business Problem

Leadership (Risk, Compliance, Operations) had a raw complaint log and one blended late rate. They could not answer:

* Which products generate the most complaints and the most remediation (monetary relief)?
* What causes the complaints?
* Are response deadlines being met, or does the average hide breaches?
* Should capacity be planned around seasons or around growth?

Missed deadlines and repeated product problems can lead to regulatory scrutiny, remediation costs, and lost customers.

## Dataset Description

| Item | Detail |
|---|---|
| Source | CFPB public consumer complaint data, obtained via [Maven Analytics](https://mavenanalytics.io/data-playground). Original data: [CFPB Consumer Complaint Database](https://www.consumerfinance.gov/data-research/consumer-complaints/) |
| Raw file | `data/raw/Consumer_Complaints.xlsx` |
| Size | 62,516 rows and 12 columns (25 columns after feature engineering) |
| Date range | 1 May 2017 to 28 Aug 2023 (2017 and 2023 are partial years) |
| Status | 61,022 closed complaints and 1,494 in progress |
| Coverage | 51 states and territories, 9 products, 7 submission channels |

**Key columns:** complaint ID, channel, date submitted, date received, state, product, issue, sub issue, company response, timely response (Yes, No, or blank when in progress).

**Engineered columns:** year, quarter, month, intake lag days, `is_in_progress`, `is_timely`, `is_late`, `has_monetary_relief`, `has_non_monetary_relief`, `has_any_relief`, `product_short`.

## Tools & Technologies

`Python` `pandas` `NumPy` `matplotlib` `Jupyter` `SQL` `PostgreSQL` `Power BI` `DAX` `Excel` `Git`

| Tool | Used for |
|---|---|
| Python | Loading, quality checks, cleaning, feature engineering, exploratory charts |
| PostgreSQL | Table design, 11 validation checks, KPI queries, CTEs, window functions, BI view |
| Power BI | 3 page interactive report with KPI cards, slicers, SLA monitor, and decision table |

## Project Structure

```
complaint-risk-sla-analytics/
├── dashboard/
│   ├── Decisions & Action Plan..png
│   ├── Executive Overview.png
│   └── Root Cause & SLA Monitor.png
├── data/
│   ├── processed/
│   │   └── complaints_clean.csv
│   └── raw/
│       └── Consumer_Complaints.xlsx
├── notebooks/
│   └── Complaint_Risk.ipynb
├── powerbi/
│   ├── Dashboard.pbit
│   └── Dashboard.pbix
├── sql/
│   ├── 01_create_table.sql
│   ├── 02_data_validation.sql
│   ├── 03_kpi_queries.sql
│   ├── 04_advanced_analysis.sql
│   ├── 05_powerbi_views.sql
│   └── 06_spike_investigation.sql
├── .gitignore
├── LICENSE
├── README.md
└── requirements.txt
```

## Data Cleaning & Preparation

| Check | Finding | Action |
|---|---|---|
| Duplicate IDs and full row duplicates | 0 | None needed |
| Missing `timely_response` | 1,494, all "In progress" | Not counted as late. Flagged `is_in_progress` and excluded from SLA rates |
| Missing sub product, sub issue, public response | 7, 10,858, 2,175 | Filled with "Not specified" or "No public response" |
| Date logic (received before submitted) | 0 | None needed |
| Intake lag outliers | Median 0 days, max 275, 435 above 30 days | Kept. Reported with the median |
| Flag integrity | Exactly one of timely, late, in progress per row | Verified in SQL |

Other steps: renamed columns, trimmed text, upper cased state codes, mapped long product names to short names, and built calendar, SLA, and relief fields.

**Assumptions:** rates use **closed complaints only**, and the **5% late rate target is assumed** (not an official rule).

## EDA & Key Insights

Analysis covered univariate counts, product by SLA and relief comparisons, a product by year late rate matrix, issue analysis inside top products, trend and seasonality tests, and outlier review of intake lag.

| # | Insight | Evidence |
|---|---|---|
| 1 | Two products carry the volume and the cost | Checking & Savings (39.69%) and Credit/Prepaid Card (25.91%) are **65.6%** of complaints and **87.27%** of monetary relief outcomes |
| 2 | Account servicing is the top cause | "Managing an account" is **24.17%** of all complaints. Managing, closing, and opening an account are **83.77%** of Checking & Savings complaints |
| 3 | The headline SLA hides 3 breaches | Overall late rate **3.94%**, but Debt Collection **6.44%**, Credit Reporting **6.32%**, Vehicle Loan **5.35%** are above 5% |
| 4 | SLA spiked in 2021 and rebounded in 2023 | **10.98%** (2021), 4.38% (2022), **6.84%** (2023 to Aug). 6 of 7 main products breached in both 2021 and 2023 |
| 5 | Money Transfer is mostly fraud | Fraud or scam is **56.50%** of Money Transfer complaints |
| 6 | Growth, not seasonality | Jan to Aug volume doubled from 4,546 (2019) to 9,131 (2023). Quarterly shares stay between 23.58% and 25.95% |
| 7 | Complaints are digital first | Web is 72.66% of submissions with a 4.34% late rate |
| 8 | July 2023 was a one off burst | 1,749 complaints, concentrated on 11 to 15 July, about half from Checking & Savings. Cause not confirmed |

**Limits:** public data (not an internal log), no dollar amounts, raw state counts (not per capita), small samples for Student Loan (39) and Payday/Personal Loan (331).

## Dashboard

A 3 page Power BI report built on the SQL view `vw_complaints_bi`. Pages 1 and 2 have Year, Product, and State slicers plus a "Clear all slicers" button.

### Page 1: Executive Overview

KPI cards (total, closed, late rate, timely rate, monetary relief rate), monthly volume trend, complaints by product, top states, and channel mix.

![Executive Overview](dashboard/Executive%20Overview.png)

### Page 2: Root Cause & SLA Monitor

Late complaints, assumed 5% target, products above target, top 10 issues, relief rate by product, late rate by product and by year, and a product by year heatmap.

![Root Cause & SLA Monitor](dashboard/Root%20Cause%20%26%20SLA%20Monitor.png)

### Page 3: Decisions & Action Plan

Six ranked decisions with evidence, owner, effort, and a flag for whether scoping is needed first. Includes a "What this analysis cannot tell us" box.

![Decisions & Action Plan](dashboard/Decisions%20%26%20Action%20Plan..png)

## How to Run This Project

**1. Clone the repository**

```bash
git clone https://github.com/<your-username>/complaint-risk-sla-analytics.git
cd complaint-risk-sla-analytics
```

**2. Set up Python and run the notebook**

```bash
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
pip install -r requirements.txt
jupyter notebook notebooks/Complaint_Risk.ipynb
```

The notebook reads `Consumer_Complaints.xlsx`. If it cannot find the file, change the path in the first code cell to `../data/raw/Consumer_Complaints.xlsx`. Run all cells to create the cleaned file in `data/processed/`.

**3. Build the PostgreSQL database**

```bash
psql -U postgres -c "CREATE DATABASE complaint_analytics;"
psql -U postgres -d complaint_analytics -f sql/01_create_table.sql
```

`01_create_table.sql` also contains a `CREATE DATABASE` line. If the database already exists, remove that line or ignore the error.

**4. Load the cleaned data**

```bash
psql -U postgres -d complaint_analytics -c "\copy complaints FROM 'data/processed/complaints_clean.csv' CSV HEADER"
```

**5. Run validation, KPIs, and the BI view**

```bash
psql -U postgres -d complaint_analytics -f sql/02_data_validation.sql
psql -U postgres -d complaint_analytics -f sql/03_kpi_queries.sql
psql -U postgres -d complaint_analytics -f sql/04_advanced_analysis.sql
psql -U postgres -d complaint_analytics -f sql/05_powerbi_views.sql
psql -U postgres -d complaint_analytics -f sql/06_spike_investigation.sql
```

Expected checks: 62,516 rows in `complaints` and in `vw_complaints_bi`.

**6. Open the dashboard**

Open `powerbi/Dashboard.pbix` in Power BI Desktop. To rebuild from your own database, open `Dashboard.pbit`, enter your PostgreSQL server and database, and connect to `vw_complaints_bi`.

## Final Recommendations & Future Work

| # | Recommendation | Owner | Effort | Scoping first? |
|---|---|---|---|---|
| 1 | Focus staffing and tooling on Checking & Savings and Credit/Prepaid Card | Operations | Low | No |
| 2 | Audit the account management process | Product | Medium | Yes |
| 3 | Scope fraud monitoring for Money Transfer | Risk | High | Yes |
| 4 | Track SLA per product every month | Compliance | Low | No |
| 5 | Investigate the 2021 late rate spike and 2023 rebound | Compliance | Medium | Yes |
| 6 | Plan capacity for growth, not seasonality | Operations | Low | No |

**Potential business impact** (not calculated savings, since the data has no dollar values): fewer missed deadlines, lower remediation exposure, less avoidable complaint volume, and a clearer view of risk by product. For the three breaching products, about 140 late complaints sit above what a 5% rate would allow.

**Future work**

* Validate the 5% target with Compliance.
* Add state population data to compare states per capita.
* Pull the 2021 late complaints and find the cause.
* Confirm what happened on 11 to 15 July 2023.
* Add dollar relief data to size remediation cost.

## Author & Contact

**Seema Kumari**, Data Analyst

📧 [seemakri136@gmail.com](mailto:seemakri136@gmail.com) · 🔗 [LinkedIn](https://linkedin.com/in/seema-kumari-375763308) 

Open to opportunities, collaborations and conversations around data analytics.

⭐ If you found this project helpful, please consider giving it a star on GitHub.
