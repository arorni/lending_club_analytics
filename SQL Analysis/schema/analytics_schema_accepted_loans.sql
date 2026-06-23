/*
================================================================================
Purpose:
Create the analytics layer by promoting the cleaned dataset without further
transformations. All columns from the clean layer are retained to preserve
maximum analytical flexibility, allowing flexibility for a wide range of current/future 
requirements without revisiting the data preparation layer.
================================================================================
*/

DROP TABLE IF EXISTS analytics.accepted_loans;

CREATE TABLE analytics.accepted_loans AS
SELECT * FROM clean.accepted_loans_cleaned;
