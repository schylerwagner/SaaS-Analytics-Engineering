-- staging.support_tickets
-- Standardizes support-ticket data while preserving ticket-level grain.

DROP TABLE IF EXISTS staging.support_tickets;

CREATE TABLE staging.support_tickets AS
SELECT
    ticket_id,
    account_id,
    submitted_at,
    closed_at,
    resolution_time_hours,
    LOWER(TRIM(priority)) AS priority,
    first_response_time_minutes,
    CAST(satisfaction_score AS INTEGER) AS satisfaction_score,
    escalation_flag,
    CASE
        WHEN closed_at IS NULL THEN 'Open'
        ELSE 'Closed'
    END AS ticket_status
FROM raw.support_tickets;

ALTER TABLE staging.support_tickets
ADD CONSTRAINT staging_support_tickets_pkey
PRIMARY KEY (ticket_id);

ALTER TABLE staging.support_tickets
ADD CONSTRAINT staging_support_tickets_account_fk
FOREIGN KEY (account_id)
REFERENCES staging.accounts(account_id);
