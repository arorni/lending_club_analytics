/*
===========================================================
Business Question:
Which borrower and loan characteristics are associated
with higher bad loan percentages?
===========================================================
*/

------------------------------------------------------------
--Bad Loan Percentage by Loan Grade
------------------------------------------------------------
SELECT
    grade,
    ROUND(AVG(bad_loan_indicator)*100,2) AS bad_loan_percentage
FROM analytics.accepted_loans
GROUP BY grade
ORDER BY grade;

------------------------------------------------------------
--Bad Loan Percentage by Loan Term
------------------------------------------------------------
SELECT
    term,
    ROUND(AVG(bad_loan_indicator)*100,2) AS bad_loan_percentage
FROM analytics.accepted_loans
GROUP BY term
ORDER BY term;


------------------------------------------------------------
--Bad Loan Percentage by FICO Band
------------------------------------------------------------
SELECT
    fico_band,
    ROUND(AVG(bad_loan_indicator)*100,2) AS bad_loan_percentage
FROM analytics.accepted_loans
GROUP BY fico_band
ORDER BY bad_loan_percentage DESC;

------------------------------------------------------------
--Bad Loan Percentage by DTI Band
------------------------------------------------------------
SELECT
    dti_band,
    ROUND(AVG(bad_loan_indicator)*100,2) AS bad_loan_percentage
FROM analytics.accepted_loans
GROUP BY dti_band
ORDER BY bad_loan_percentage DESC;


------------------------------------------------------------
--Bad Loan Percentage by Home Ownership
------------------------------------------------------------
SELECT
    home_ownership_group,
    ROUND(AVG(bad_loan_indicator)*100,2) AS bad_loan_percentage
FROM analytics.accepted_loans
GROUP BY home_ownership_group
ORDER BY bad_loan_percentage DESC;

------------------------------------------------------------
--Combined Analysis - Grade × Loan Term
------------------------------------------------------------
SELECT
    grade,
    term, count(*), 
    ROUND(AVG(bad_loan_indicator) * 100, 2) AS bad_loan_percentage
FROM analytics.accepted_loans
GROUP BY grade, term
ORDER BY grade, term;
