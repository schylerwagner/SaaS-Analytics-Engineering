--This dimension gives downstream reporting a clean customer-level table for segmentation by industry, geography, acquisition source, initial plan, and trial origin.

DROP TABLE IF EXISTS analytics.dim_account;

CREATE TABLE analytics.dim_account AS
SELECT
    account_id,
    account_name,
    industry,
    country,
    signup_date,
    referral_source,
    plan_tier AS initial_plan_tier,
    seats AS initial_seats,
    is_trial AS started_as_trial
FROM staging.accounts;

ALTER TABLE analytics.dim_account
ADD CONSTRAINT analytics_dim_account_pkey
PRIMARY KEY (account_id);
