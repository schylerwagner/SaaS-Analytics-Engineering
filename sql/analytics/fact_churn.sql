-- This fact table captures account-level churn events
-- for downstream retention and churn analysis.

DROP TABLE IF EXISTS analytics.fact_churn;

CREATE TABLE analytics.fact_churn AS
SELECT
    churn_event_id,
    account_id,
    churn_date,
    reason_code,
    refund_amount_usd,
    preceding_upgrade_flag,
    preceding_downgrade_flag,
    is_reactivation,
    feedback_text
FROM staging.churn_events;

ALTER TABLE analytics.fact_churn
ADD CONSTRAINT analytics_fact_churn_pkey
PRIMARY KEY (churn_event_id);

ALTER TABLE analytics.fact_churn
ADD CONSTRAINT analytics_fact_churn_account_fk
FOREIGN KEY (account_id)
REFERENCES analytics.dim_account(account_id);
