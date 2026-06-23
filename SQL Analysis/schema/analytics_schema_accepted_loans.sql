/*
================================================================================
Feature Engineering

Additional analytical features were derived from the cleaned dataset to
simplify business reporting, support exploratory analysis, and enable
meaningful segmentation of borrowers.

Derived features include:
- Time-based features:
    • issue_year
    • issue_month
    • issue_year_month

- Loan performance indicators:
    • bad_loan_indicator
    • loan_category

- Credit profile features:
    • avg_fico_score
    • fico_band
    • dti_band

- Borrower segmentation:
    • annual_inc_band
    • emp_length_band
    • home_ownership_group

- Loan characteristics:
    • loan_amount_band
    • purpose_group

While several features were created to support exploratory analysis, only those relevant 
to the selected business questions were used in the final analysis.
================================================================================
*/

DROP TABLE IF EXISTS analytics.accepted_loans;

CREATE TABLE analytics.accepted_loans AS
SELECT
    *,

    /* Time Features */
    EXTRACT(YEAR FROM issue_d)::INT AS issue_year,
    EXTRACT(MONTH FROM issue_d)::INT AS issue_month,
    TO_CHAR(issue_d,'YYYY-MM') AS issue_year_month,

    /* Loan Performance */
    CASE
        WHEN LOWER(loan_status) IN ('charged off','default')
        THEN 1
        ELSE 0
    END AS bad_loan_indicator,

    CASE
        WHEN LOWER(loan_status) = 'fully paid' THEN 'good'
        WHEN LOWER(loan_status) IN ('charged off','default') THEN 'bad'
        WHEN LOWER(loan_status) IN
            ('in grace period',
             'late (16-30 days)',
             'late (31-120 days)')
            THEN 'delinquent'
        WHEN LOWER(loan_status)='current'
            THEN 'current'
        ELSE 'other'
    END AS loan_category,

    /* Credit Profile */
    
  ((fico_range_low + fico_range_high)/2.0)::NUMERIC(5,1)
        AS avg_fico_score,

    CASE
        WHEN fico_range_low IS NULL
          OR fico_range_high IS NULL
            THEN 'Missing'
        WHEN ((fico_range_low + fico_range_high)/2.0) < 680
            THEN 'Low'
        WHEN ((fico_range_low + fico_range_high)/2.0) < 720
            THEN 'Medium'
        ELSE 'High'
    END AS fico_band,

    CASE
        WHEN dti IS NULL THEN 'Missing'
        WHEN dti < 15 THEN 'Low'
        WHEN dti < 30 THEN 'Medium'
        ELSE 'High'
    END AS dti_band,

    /* Borrower Segmentation */
    CASE
        WHEN annual_inc IS NULL THEN 'Missing'
        WHEN annual_inc < 25000 THEN '<25k'
        WHEN annual_inc < 50000 THEN '25k-50k'
        WHEN annual_inc < 100000 THEN '50k-100k'
        ELSE '100k+'
    END AS annual_inc_band,

    CASE
        WHEN emp_length IS NULL THEN 'Missing'
        WHEN emp_length <= 2 THEN 'Early Career'
        WHEN emp_length <= 6 THEN 'Mid Career'
        ELSE 'Experienced'
    END AS emp_length_band,

    CASE
        WHEN home_ownership IN ('ANY','NONE','OTHER')
            THEN 'OTHER'
        ELSE home_ownership
    END AS home_ownership_group,

    /* Loan Characteristics */
    CASE
        WHEN purpose IN
            ('educational',
             'renewable_energy',
             'wedding',
             'house',
             'moving',
             'vacation')
            THEN 'other'
        ELSE purpose
    END AS purpose_group,

    CASE
        WHEN loan_amnt IS NULL THEN 'Missing'
        WHEN loan_amnt < 5000 THEN '<5k'
        WHEN loan_amnt < 10000 THEN '5k-10k'
        WHEN loan_amnt < 15000 THEN '10k-15k'
        WHEN loan_amnt < 20000 THEN '15k-20k'
        ELSE '20k+'
    END AS loan_amount_band

FROM clean.accepted_loans_cleaned;
