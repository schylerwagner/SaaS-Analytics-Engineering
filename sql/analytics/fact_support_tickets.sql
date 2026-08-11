-- This fact table captures support-ticket activity
-- for downstream customer service and satisfaction analysis.

DROP TABLE IF EXISTS analytics.fact_support_tickets;

CREATE TABLE analytics.fact_support_tickets AS
SELECT
    ticket_id,
    account_id,
    submitted_at,
    closed_at,
    resolution_time_hours,
    priority,
    first_response_time_minutes,
    satisfaction_score,
    escalation_flag,
    ticket_status
FROM staging.support_tickets;

ALTER TABLE analytics.fact_support_tickets
ADD CONSTRAINT analytics_fact_support_tickets_pkey
PRIMARY KEY (ticket_id);

ALTER TABLE analytics.fact_support_tickets
ADD CONSTRAINT analytics_fact_support_tickets_account_fk
FOREIGN KEY (account_id)
REFERENCES analytics.dim_account(account_id);
