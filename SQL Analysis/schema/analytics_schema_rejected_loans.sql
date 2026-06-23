/*
================================================================================
Purpose:
Create the analytics-ready table for rejected loan applications by retaining
the business-relevant attributes from the clean layer and deriving additional
features to support reporting and analysis.

Transformations Performed:
- Extracted application year, month, and year-month from the application date
  to enable time-based trend analysis.
- Converted employment length from a categorical field into a numeric
  representation (employment_years) to facilitate aggregation, filtering,
  and future analytical use.
- Retained all relevant cleaned attributes required for exploratory analysis
  and downstream business reporting.
================================================================================
*/

DROP TABLE IF EXISTS analytics.rejected_loans;
CREATE TABLE analytics.rejected_loans AS
SELECT
    id,
    amount_requested,
    application_date,
    EXTRACT(YEAR FROM application_date)::INT AS application_year,
    EXTRACT(MONTH FROM application_date)::INT AS application_month,
    TO_CHAR(application_date, 'YYYY-MM') AS application_year_month,
    risk_score,
    dti,
    state,
    employment_length,
	CASE
    WHEN employment_length = '< 1 year' THEN 0
    WHEN employment_length = '1 year' THEN 1
    WHEN employment_length = '2 years' THEN 2
    WHEN employment_length = '3 years' THEN 3
    WHEN employment_length = '4 years' THEN 4
    WHEN employment_length = '5 years' THEN 5
    WHEN employment_length = '6 years' THEN 6
    WHEN employment_length = '7 years' THEN 7
    WHEN employment_length = '8 years' THEN 8
    WHEN employment_length = '9 years' THEN 9
    WHEN employment_length = '10+ years' THEN 10
    ELSE NULL
END AS employment_years
FROM clean.rejected_loans_cleaned
