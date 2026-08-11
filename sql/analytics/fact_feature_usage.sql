-- This fact table captures feature-level usage events
-- for downstream product engagement analysis.

DROP TABLE IF EXISTS analytics.fact_feature_usage;

CREATE TABLE analytics.fact_feature_usage AS
SELECT
    raw_usage_row_id,
    usage_id,
    subscription_id,
    usage_date,
    feature_name,
    usage_count,
    usage_duration_secs,
    error_count,
    is_beta_feature
FROM staging.feature_usage;

ALTER TABLE analytics.fact_feature_usage
ADD CONSTRAINT analytics_fact_feature_usage_pkey
PRIMARY KEY (raw_usage_row_id);

ALTER TABLE analytics.fact_feature_usage
ADD CONSTRAINT analytics_fact_feature_usage_subscription_fk
FOREIGN KEY (subscription_id)
REFERENCES analytics.dim_subscription(subscription_id);
