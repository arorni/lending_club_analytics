/*
===========================================================
Business Question:
How has the accepted loan portfolio evolved over time?

Objective:
Analyze yearly lending activity to understand changes in loan
originations, funding volume, loan characteristics, and portfolio
performance over time.

The analysis focuses on:
- Loan origination volume
- Total funded amount
- Average loan amount
- Average interest rate
- Bad loan percentage
- Distribution of loan performance categories

===========================================================
*/

------------------------------------------------------------
-- Annual Lending Portfolio Performance
------------------------------------------------------------

SELECT
    issue_year,
    TO_CHAR(COUNT(*), 'FM999,999,999,990') AS total_loans,
    TO_CHAR(ROUND(SUM(loan_amnt) / 1000000), 'FM999,999,999,990')
        AS "total_loan_amount ($M)",
    ROUND(AVG(bad_loan_indicator) * 100, 2)
        AS bad_loan_percentage,
    TO_CHAR(ROUND(AVG(loan_amnt), 2), 'FM999,999,999,990')
        AS avg_loan_amount,
    ROUND(AVG(int_rate), 2)
        AS avg_interest_rate
FROM analytics.accepted_loans
GROUP BY issue_year
ORDER BY issue_year;


------------------------------------------------------------
-- Annual Loan Performance Distribution
------------------------------------------------------------

SELECT
    issue_year,

    ROUND(
        SUM(CASE WHEN loan_category = 'good' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS good_pct,

    ROUND(
        SUM(CASE WHEN loan_category = 'bad' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS bad_pct,

    ROUND(
        SUM(CASE WHEN loan_category = 'delinquent' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS delinquent_pct,

    ROUND(
        SUM(CASE WHEN loan_category = 'current' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS current_pct

FROM analytics.accepted_loans
GROUP BY issue_year
ORDER BY issue_year;
