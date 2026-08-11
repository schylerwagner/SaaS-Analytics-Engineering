-- This fact table captures subscription-level recurring revenue
-- for downstream revenue and growth analysis.

DROP TABLE IF EXISTS analytics.fact_subscription_revenue;

CREATE TABLE analytics.fact_subscription_revenue AS
SELECT
    subscription_id,
    account_id,
    start_date,
    end_date,
    mrr_amount,
    arr_amount
FROM staging.subscriptions;

ALTER TABLE analytics.fact_subscription_revenue
ADD CONSTRAINT analytics_fact_subscription_revenue_pkey
PRIMARY KEY (subscription_id);

ALTER TABLE analytics.fact_subscription_revenue
ADD CONSTRAINT analytics_fact_subscription_revenue_subscription_fk
FOREIGN KEY (subscription_id)
REFERENCES analytics.dim_subscription(subscription_id);

ALTER TABLE analytics.fact_subscription_revenue
ADD CONSTRAINT analytics_fact_subscription_revenue_account_fk
FOREIGN KEY (account_id)
REFERENCES analytics.dim_account(account_id);
