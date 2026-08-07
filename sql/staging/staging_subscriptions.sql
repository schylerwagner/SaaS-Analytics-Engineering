-- staging.subscriptions
-- Standardizes subscription data and derives a consistent lifecycle status.

DROP TABLE IF EXISTS staging.subscriptions CASCADE;

CREATE TABLE staging.subscriptions AS
SELECT
    subscription_id,
    account_id,
    start_date,
    end_date,
    INITCAP(TRIM(plan_tier)) AS plan_tier,
    seats,
    mrr_amount,
    arr_amount,
    is_trial,
    upgrade_flag,
    downgrade_flag,
    churn_flag,
    LOWER(TRIM(billing_frequency)) AS billing_frequency,
    auto_renew_flag,
    CASE
        WHEN is_trial = TRUE THEN 'Trial'
        WHEN churn_flag = TRUE THEN 'Churned'
        WHEN churn_flag = FALSE
             AND end_date IS NULL THEN 'Active'
        ELSE 'Review'
    END AS subscription_status
FROM raw.subscriptions;

ALTER TABLE staging.subscriptions
ADD CONSTRAINT staging_subscriptions_pkey
PRIMARY KEY (subscription_id);

ALTER TABLE staging.subscriptions
ADD CONSTRAINT staging_subscriptions_account_fk
FOREIGN KEY (account_id)
REFERENCES staging.accounts(account_id);
