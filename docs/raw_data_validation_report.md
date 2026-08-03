# Data Quality Report

## Raw Table Row Counts

| Table | Row Count |
|---|---:|
| accounts |500|
| subscriptions |5000|
| feature_usage |25000|
| support_tickets |2000|
| churn_events |600|

## Primary Key Validation

| Table | Expected Primary Key | Duplicate Records | Result |
|--------|----------------------|------------------:|--------|
| Accounts | account_id |0|Passed|
| Subscriptions | subscription_id |0|Passed|
| Feature Usage | usage_id* |21|Source Data Issue|
| Support Tickets | ticket_id |0|Passed|
| Churn Events | churn_event_id |0|Passed|

\* **Feature Usage:** The source documentation describes `usage_id` as representing a unique usage event. During ingestion, 21 duplicate `usage_id` values were identified in the source CSV. To preserve source fidelity, the primary key constraint was removed and a surrogate key (`raw_usage_row_id`) was introduced. Duplicate investigation will continue during subsequent data validation phases.

## Referential Integrity Validation

| Relationship | Orphaned Records | Result |
|---|---:|---|
| Subscriptions → Accounts |0|Passed|
| Feature Usage → Subscriptions |0|Passed|
| Support Tickets → Accounts |0|Passed|
| Churn Events → Accounts |0|Passed|

This check verifies the dataset’s claim that all 'account_id' and 'subscription_id' relationships are referentially complete.
