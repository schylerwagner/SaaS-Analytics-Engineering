-- This dimension provides subscription-level descriptive attributes
-- for downstream segmentation and lifecycle analysis.

DROP TABLE IF EXISTS analytics.dim_subscription;

CREATE TABLE analytics.dim_subscription AS
SELECT
    subscription_id,
    account_id,
    start_date,
    end_date,
    plan_tier,
    seats,
    is_trial,
    upgrade_flag,
    downgrade_flag,
    churn_flag,
    billing_frequency,
    auto_renew_flag,
    subscription_status
FROM staging.subscriptions;

ALTER TABLE analytics.dim_subscription
ADD CONSTRAINT analytics_dim_subscription_pkey
PRIMARY KEY (subscription_id);

ALTER TABLE analytics.dim_subscription
ADD CONSTRAINT analytics_dim_subscription_account_fk
FOREIGN KEY (account_id)
REFERENCES analytics.dim_account(account_id);
