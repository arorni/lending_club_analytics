/*
================================================================================
Purpose:
Transform raw rejected loan application data into a clean, analysis-ready dataset.

Data Cleaning Performed:
- Converted all text-based fields from the raw layer to appropriate PostgreSQL
  data types (BIGINT, NUMERIC, DATE, and VARCHAR).
- Removed leading and trailing spaces using TRIM().
- Converted blank strings to NULL using NULLIF() to ensure proper handling of
  missing values.
- Applied basic data validation and cleansing, including:
    • Generated a unique surrogate key using ROW_NUMBER().
    • Converted application dates to PostgreSQL DATE format.
    • Removed the '%' symbol from Debt-to-Income (DTI) values and converted
      them to NUMERIC.
    • Replaced invalid DTI placeholder values (-1, 9999, 99999, 199998) with NULL.
    • Standardized missing Employment Length values as 'Missing'.

Data Quality Checks:
- Added a primary key on the generated ID.
- Verified record counts between raw and clean layers.
================================================================================
*/

drop table if exists clean.rejected_loans_cleaned;
CREATE TABLE clean.rejected_loans_cleaned AS
SELECT
    ROW_NUMBER() OVER()::BIGINT AS id,
	NULLIF(TRIM("Amount Requested"), '')::NUMERIC(12,2) AS amount_requested,
	TO_DATE(NULLIF(TRIM("Application Date"), ''), 'YYYY-MM-DD') AS application_date,
	NULLIF(TRIM("Loan Title"), '')::VARCHAR(150) AS loan_title,
	NULLIF(TRIM("Risk_Score"), '')::NUMERIC(6,2) AS risk_score,
	CASE
    WHEN NULLIF(TRIM("Debt-To-Income Ratio"), '') IS NULL THEN NULL
    ELSE
        CASE
            WHEN REPLACE(TRIM("Debt-To-Income Ratio"), '%', '')::NUMERIC
                 IN (-1, 9999, 99999, 199998)
            THEN NULL
            ELSE REPLACE(TRIM("Debt-To-Income Ratio"), '%', '')::NUMERIC(12,2)
        END
END AS dti,
	TRIM("State")::VARCHAR(2) AS state,
	COALESCE(TRIM("Employment Length"),'Missing')::VARCHAR(20) AS employment_length
FROM raw.rejected_loans_raw


/* Adding primary key */
ALTER TABLE clean.rejected_loans_cleaned
ADD PRIMARY KEY (id);


/* Verifying record count from both raw and clean rejected loans tables. */
SELECT COUNT(*) FROM raw.rejected_loans_raw;

SELECT COUNT(*) FROM clean.rejected_loans_cleaned;


