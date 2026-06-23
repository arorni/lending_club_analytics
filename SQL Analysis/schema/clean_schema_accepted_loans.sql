/*
================================================================================
Purpose:
Transform raw accepted loan data into a clean, analysis-ready dataset.

Data Cleaning Performed:
- Converted all text-based fields from the raw layer to appropriate PostgreSQL
  data types (BIGINT, SMALLINT, NUMERIC, DATE, VARCHAR).
- Removed leading and trailing spaces using TRIM().
- Converted blank strings to NULL using NULLIF() to ensure proper handling of
  missing values.
- Applied basic data validation and cleansing, including:
    • Excluding records with invalid loan IDs.
    • Converting employment length to numeric years.
    • Replacing invalid DTI values (negative values) with NULL.
    • Standardizing date fields.
    • Extracting numeric values from fields such as loan term.
- Preserved only business-relevant columns required for downstream analytics.

Data Quality Checks:
- Added a primary key on loan ID.
- Verified record counts between raw and clean layers.
- Checked for duplicate loan IDs.
================================================================================
*/

CREATE TABLE clean.accepted_loans_cleaned AS
SELECT
    TRIM(id)::BIGINT AS id,

    NULLIF(acc_now_delinq, '')::NUMERIC::SMALLINT AS acc_now_delinq,
    NULLIF(acc_open_past_24mths, '')::NUMERIC::SMALLINT AS acc_open_past_24mths,
    TRIM(addr_state)::VARCHAR(2) AS app_state,
    NULLIF(TRIM(annual_inc), '')::NUMERIC(12,2) AS annual_inc,
    NULLIF(TRIM(bc_open_to_buy), '')::NUMERIC(12,2) AS bc_open_to_buy,
    NULLIF(TRIM(bc_util), '')::NUMERIC(5,2) AS bc_util,
    NULLIF(chargeoff_within_12_mths, '')::NUMERIC::SMALLINT AS chargeoff_within_12_mths,
    TRIM(debt_settlement_flag)::VARCHAR(1) AS debt_settlement_flag,
    NULLIF(delinq_2yrs, '')::NUMERIC::SMALLINT AS delinq_2yrs,
    NULLIF(TRIM(delinq_amnt), '')::NUMERIC(12,2) AS delinq_amnt,
    CASE
        WHEN NULLIF(TRIM(dti), '') IS NULL THEN NULL
        WHEN NULLIF(TRIM(dti), '')::NUMERIC < 0 THEN NULL
        ELSE NULLIF(TRIM(dti), '')::NUMERIC(6,2)
    END AS dti,
    TO_DATE(NULLIF(TRIM(earliest_cr_line), ''), 'Mon-YYYY') AS earliest_cr_line,
    CASE
        WHEN NULLIF(TRIM(emp_length), '') IS NULL THEN NULL
        WHEN TRIM(emp_length) = '< 1 year' THEN 0
        WHEN TRIM(emp_length) = '10+ years' THEN 10
        ELSE REGEXP_REPLACE(TRIM(emp_length), '[^0-9]', '', 'g')::SMALLINT
    END AS emp_length,
    NULLIF(fico_range_high, '')::NUMERIC::SMALLINT AS fico_range_high,
    NULLIF(fico_range_low, '')::NUMERIC::SMALLINT AS fico_range_low,

    NULLIF(TRIM(funded_amnt), '')::NUMERIC(12,2) AS funded_amnt,
    TRIM(grade)::VARCHAR(2) AS grade,
    TRIM(home_ownership)::VARCHAR(20) AS home_ownership,
    NULLIF(inq_last_6mths, '')::NUMERIC::SMALLINT AS inq_last_6mths,

    NULLIF(TRIM(installment), '')::NUMERIC(10,2) AS installment,
    NULLIF(TRIM(int_rate), '')::NUMERIC(5,2) AS int_rate,

    TO_DATE(NULLIF(TRIM(issue_d), ''), 'Mon-YYYY') AS issue_d,
    TO_DATE(NULLIF(TRIM(last_credit_pull_d), ''), 'Mon-YYYY') AS last_credit_pull_d,

    NULLIF(last_fico_range_high, '')::NUMERIC::SMALLINT AS last_fico_range_high,
    NULLIF(last_fico_range_low, '')::NUMERIC::SMALLINT AS last_fico_range_low,

    NULLIF(TRIM(last_pymnt_amnt), '')::NUMERIC(12,2) AS last_pymnt_amt,
    TO_DATE(NULLIF(TRIM(last_pymnt_d), ''), 'Mon-YYYY') AS last_pymnt_d,

    NULLIF(TRIM(loan_amnt), '')::NUMERIC(12,2) AS loan_amnt,
    TRIM(loan_status)::VARCHAR(30) AS loan_status,
    NULLIF(mort_acc, '')::NUMERIC::SMALLINT AS mort_acc,
    NULLIF(open_acc, '')::NUMERIC::SMALLINT AS open_acc,
    NULLIF(out_prncp, '')::NUMERIC(12,2) AS out_prncp,
    NULLIF(pct_tl_nvr_dlq, '')::NUMERIC(5,2) AS pct_tl_nvr_dlq,
    NULLIF(percent_bc_gt_75, '')::NUMERIC(5,2) AS percent_bc_gt_75,
    NULLIF(pub_rec, '')::NUMERIC::SMALLINT AS pub_rec,
    NULLIF(pub_rec_bankruptcies, '')::NUMERIC::SMALLINT AS pub_rec_bankruptcies,
    TRIM(purpose)::VARCHAR(30) AS purpose,
    TRIM(pymnt_plan)::VARCHAR(10) AS pymnt_plan,
    NULLIF(TRIM(recoveries), '')::NUMERIC(12,2) AS recoveries,
    NULLIF(TRIM(revol_bal), '')::NUMERIC(12,2) AS revol_bal,
    NULLIF(TRIM(revol_util), '')::NUMERIC(5,2) AS revol_util,
    TRIM(sub_grade)::VARCHAR(2) AS sub_grade,
    REGEXP_REPLACE(TRIM(term), '[^0-9]', '', 'g')::SMALLINT AS term,
    TRIM(title)::VARCHAR(100) AS title,
    NULLIF(TRIM(tot_coll_amt), '')::NUMERIC(12,2) AS tot_coll_amt,
    NULLIF(TRIM(tot_cur_bal), '')::NUMERIC(12,2) AS tot_cur_bal,
    NULLIF(TRIM(tot_hi_cred_lim), '')::NUMERIC(12,2) AS tot_hi_cred_lim,
    NULLIF(total_acc, '')::NUMERIC::SMALLINT AS total_acc,
    NULLIF(TRIM(total_bal_ex_mort), '')::NUMERIC(12,2) AS total_bal_ex_mort,
    NULLIF(TRIM(total_bc_limit), '')::NUMERIC(12,2) AS total_bc_limit,
    NULLIF(TRIM(total_il_high_credit_limit), '')::NUMERIC(12,2) AS total_il_high_credit_limit,
    NULLIF(TRIM(total_pymnt), '')::NUMERIC(12,2) AS total_pymnt,
    NULLIF(TRIM(total_rec_int), '')::NUMERIC(12,2) AS total_rec_int,
    NULLIF(TRIM(total_rec_late_fee), '')::NUMERIC(12,2) AS total_rec_late_fee,
    NULLIF(TRIM(total_rec_prncp), '')::NUMERIC(12,2) AS total_rec_prncp,
    NULLIF(TRIM(total_rev_hi_lim), '')::NUMERIC(12,2) AS total_rev_hi_lim,
    TRIM(verification_status)::VARCHAR(30) AS verification_status
FROM raw.accepted_loans_raw
WHERE NULLIF(TRIM(id), '') ~ '^[0-9]+(\.0)?$';

/*Primary key creation*/
ALTER TABLE clean.accepted_loans_cleaned
ADD PRIMARY KEY (id);

/*Verifying row count for both raw and clean tables*/
SELECT COUNT(*) FROM raw.accepted_loans_raw;

SELECT COUNT(*) FROM clean.accepted_loans_cleaned;

/* There will be a difference of 32 records from raw table (Records with invalid ID have been skipped */

/*Verifying the presence of duplicate id in the clean table */
SELECT COUNT(*) - COUNT(DISTINCT id) AS duplicate_ids
FROM clean.accepted_loans_cleaned;

