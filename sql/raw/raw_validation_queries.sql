-- Raw data validation queries
-- Purpose: validate source structure, relationships,
-- null behavior, and business rules before staging.


-- =========================================================
-- 1. Row Count Validation
-- =========================================================

SELECT 'accounts' AS table_name, COUNT(*) AS row_count
FROM raw.accounts

UNION ALL

SELECT 'subscriptions', COUNT(*)
FROM raw.subscriptions

UNION ALL

SELECT 'feature_usage', COUNT(*)
FROM raw.feature_usage

UNION ALL

SELECT 'support_tickets', COUNT(*)
FROM raw.support_tickets

UNION ALL

SELECT 'churn_events', COUNT(*)
FROM raw.churn_events;


-- Expected:
-- accounts          500
-- subscriptions    5000
-- feature_usage   25000
-- support_tickets  2000
-- churn_events      600



-- =========================================================
-- 2. Candidate Primary Key / Duplicate Validation
-- =========================================================

-- Accounts
SELECT
    account_id,
    COUNT(*) AS duplicate_count
FROM raw.accounts
GROUP BY account_id
HAVING COUNT(*) > 1;


-- Subscriptions
SELECT
    subscription_id,
    COUNT(*) AS duplicate_count
FROM raw.subscriptions
GROUP BY subscription_id
HAVING COUNT(*) > 1;


-- Feature Usage
-- Source documentation described usage_id as unique,
-- but duplicate values exist in the source data.

SELECT
    usage_id,
    COUNT(*) AS duplicate_count
FROM raw.feature_usage
GROUP BY usage_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- Support Tickets
SELECT
    ticket_id,
    COUNT(*) AS duplicate_count
FROM raw.support_tickets
GROUP BY ticket_id
HAVING COUNT(*) > 1;


-- Churn Events
SELECT
    churn_event_id,
    COUNT(*) AS duplicate_count
FROM raw.churn_events
GROUP BY churn_event_id
HAVING COUNT(*) > 1;



-- =========================================================
-- 3. Referential Integrity Validation
-- =========================================================

-- Subscriptions → Accounts
SELECT
    s.account_id
FROM raw.subscriptions s
LEFT JOIN raw.accounts a
    ON s.account_id = a.account_id
WHERE a.account_id IS NULL;


-- Feature Usage → Subscriptions
SELECT
    fu.subscription_id
FROM raw.feature_usage fu
LEFT JOIN raw.subscriptions s
    ON fu.subscription_id = s.subscription_id
WHERE s.subscription_id IS NULL;


-- Support Tickets → Accounts
SELECT
    st.account_id
FROM raw.support_tickets st
LEFT JOIN raw.accounts a
    ON st.account_id = a.account_id
WHERE a.account_id IS NULL;


-- Churn Events → Accounts
SELECT
    ce.account_id
FROM raw.churn_events ce
LEFT JOIN raw.accounts a
    ON ce.account_id = a.account_id
WHERE a.account_id IS NULL;



-- =========================================================
-- 4. Null Value Profiling
-- =========================================================

SELECT
    COUNT(*) FILTER (WHERE end_date IS NULL)
        AS subscription_end_date_nulls
FROM raw.subscriptions;


SELECT
    COUNT(*) FILTER (WHERE closed_at IS NULL)
        AS support_closed_at_nulls,
    COUNT(*) FILTER (WHERE satisfaction_score IS NULL)
        AS satisfaction_score_nulls
FROM raw.support_tickets;


SELECT
    COUNT(*) FILTER (WHERE feedback_text IS NULL)
        AS churn_feedback_nulls
FROM raw.churn_events;


-- Expected results from source profiling:
-- subscriptions.end_date          = 4514
-- support_tickets.closed_at       = 0
-- support_tickets.satisfaction_score = 825
-- churn_events.feedback_text      = 148



-- =========================================================
-- 5. Business Rule Validation
-- =========================================================

-- ARR should equal MRR × 12
SELECT *
FROM raw.subscriptions
WHERE ABS(arr_amount - (mrr_amount * 12)) > 0.01;


-- Subscription cannot end before it starts
SELECT *
FROM raw.subscriptions
WHERE end_date < start_date;


-- Churned subscriptions should have an end date
SELECT *
FROM raw.subscriptions
WHERE churn_flag = TRUE
  AND end_date IS NULL;


-- Non-churned subscriptions should not have an end date
SELECT *
FROM raw.subscriptions
WHERE churn_flag = FALSE
  AND end_date IS NOT NULL;


-- Revenue should not be negative
SELECT *
FROM raw.subscriptions
WHERE mrr_amount < 0
   OR arr_amount < 0;


-- Seat counts should be positive
SELECT *
FROM raw.subscriptions
WHERE seats <= 0;



-- =========================================================
-- 6. Support Ticket Validation
-- =========================================================

-- closed_at should not occur before submitted_at
SELECT *
FROM raw.support_tickets
WHERE closed_at < submitted_at;


-- Resolution time should not be negative
SELECT *
FROM raw.support_tickets
WHERE resolution_time_hours < 0;


-- First response time should not be negative
SELECT *
FROM raw.support_tickets
WHERE first_response_time_minutes < 0;


-- Satisfaction score should remain within the expected range
SELECT *
FROM raw.support_tickets
WHERE satisfaction_score IS NOT NULL
  AND satisfaction_score NOT BETWEEN 1 AND 5;



-- =========================================================
-- 7. Feature Usage Validation
-- =========================================================

SELECT
    MIN(usage_count) AS min_usage_count,
    MAX(usage_count) AS max_usage_count,
    AVG(usage_count) AS avg_usage_count,
    MIN(usage_duration_secs) AS min_usage_duration_secs,
    MAX(usage_duration_secs) AS max_usage_duration_secs,
    AVG(usage_duration_secs) AS avg_usage_duration_secs
FROM raw.feature_usage;


SELECT *
FROM raw.feature_usage
WHERE usage_count < 0
   OR usage_duration_secs < 0
   OR error_count < 0;



-- =========================================================
-- 8. Churn Event Validation
-- =========================================================

-- Refunds should not be negative
SELECT *
FROM raw.churn_events
WHERE refund_amount_usd < 0;


-- Churn dates should not precede account signup
SELECT
    ce.*
FROM raw.churn_events ce
JOIN raw.accounts a
    ON ce.account_id = a.account_id
WHERE ce.churn_date < a.signup_date;
