-- staging.churn_events
-- Standardizes churn-event data while preserving event-level grain.

DROP TABLE IF EXISTS staging.churn_events;

CREATE TABLE staging.churn_events AS
SELECT
    churn_event_id,
    account_id,
    churn_date,
    LOWER(TRIM(reason_code)) AS reason_code,
    refund_amount_usd,
    preceding_upgrade_flag,
    preceding_downgrade_flag,
    is_reactivation,
    TRIM(feedback_text) AS feedback_text
FROM raw.churn_events;

ALTER TABLE staging.churn_events
ADD CONSTRAINT staging_churn_events_pkey
PRIMARY KEY (churn_event_id);

ALTER TABLE staging.churn_events
ADD CONSTRAINT staging_churn_events_account_fk
FOREIGN KEY (account_id)
REFERENCES staging.accounts(account_id);
