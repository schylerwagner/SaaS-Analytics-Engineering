-- staging.feature_usage
-- Standardizes feature usage data while preserving source traceability.

DROP TABLE IF EXISTS staging.feature_usage;

CREATE TABLE staging.feature_usage AS
SELECT
    raw_usage_row_id,
    usage_id,
    subscription_id,
    usage_date,
    TRIM(feature_name) AS feature_name,
    usage_count,
    usage_duration_secs,
    error_count,
    is_beta_feature
FROM raw.feature_usage;

ALTER TABLE staging.feature_usage
ADD CONSTRAINT staging_feature_usage_pkey
PRIMARY KEY (raw_usage_row_id);

ALTER TABLE staging.feature_usage
ADD CONSTRAINT staging_feature_usage_subscription_fk
FOREIGN KEY (subscription_id)
REFERENCES staging.subscriptions(subscription_id);
