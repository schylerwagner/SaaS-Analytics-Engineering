-- staging.accounts
-- Standardizes raw account data while preserving one row per account.

DROP TABLE IF EXISTS staging.accounts CASCADE;

CREATE TABLE staging.accounts AS
SELECT
    account_id,
    TRIM(account_name) AS account_name,
    TRIM(industry) AS industry,
    UPPER(TRIM(country)) AS country,
    signup_date,
    LOWER(TRIM(referral_source)) AS referral_source,
    INITCAP(TRIM(plan_tier)) AS plan_tier,
    seats,
    is_trial,
    churn_flag
FROM raw.accounts;

ALTER TABLE staging.accounts
ADD CONSTRAINT staging_accounts_pkey
PRIMARY KEY (account_id);
