/*
===========================================================
Business Question:
How do the geographic distributions of accepted and rejected
loan applications compare across states?

Objective:
Compare accepted and rejected application rankings to identify
states with the largest differences in lending activity.

Note:
The analysis is descriptive and compares application rankings
over the common date range (2007-06-01 to 2018-12-01).
===========================================================
*/

WITH accepted_applications AS (
    SELECT
        app_state AS state,
        COUNT(*) AS accepted_applications
    FROM analytics.accepted_loans
    WHERE issue_d BETWEEN DATE '2007-06-01' AND DATE '2018-12-01'
      AND app_state IS NOT NULL
    GROUP BY app_state
),

rejected_applications AS (
    SELECT
        state,
        COUNT(*) AS rejected_applications
    FROM analytics.rejected_loans
    WHERE application_date BETWEEN DATE '2007-06-01' AND DATE '2018-12-01'
      AND state IS NOT NULL
    GROUP BY state
),

state_comparison AS (
    SELECT
        COALESCE(a.state, r.state) AS state,
        COALESCE(a.accepted_applications, 0) AS accepted_applications,
        COALESCE(r.rejected_applications, 0) AS rejected_applications
    FROM accepted_applications a
    FULL OUTER JOIN rejected_applications r
        ON a.state = r.state
),

ranked_states AS (
    SELECT
        state,
        accepted_applications,
        rejected_applications,
        DENSE_RANK() OVER (ORDER BY accepted_applications DESC) AS accepted_rank,
        DENSE_RANK() OVER (ORDER BY rejected_applications DESC) AS rejected_rank
    FROM state_comparison
)

SELECT
    state,
    TO_CHAR(accepted_applications, 'FM999,999,999,990') AS accepted_applications,
    accepted_rank,
    TO_CHAR(rejected_applications, 'FM999,999,999,990') AS rejected_applications,
    rejected_rank,
    ABS(accepted_rank - rejected_rank) AS rank_gap
FROM ranked_states
WHERE accepted_rank <= 5
   OR rejected_rank <= 5
ORDER BY
    rank_gap DESC,
    rejected_rank,
    accepted_rank;
