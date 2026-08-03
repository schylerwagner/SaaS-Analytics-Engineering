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

## Null Value Profiling

| Table | Column | Null Count | Expected? | Notes |
|---|---|---:|---|---|
| Subscriptions | `end_date` |4514| Yes | Active subscriptions may not have an end date |
| Support Tickets | `closed_at` |0| Possibly | May represent unresolved tickets |
| Support Tickets | `satisfaction_score` |825| Yes | Null indicates no customer response |
| Churn Events | `feedback_text` |148| Yes | Feedback is optional |

## Null Value Interpretation

| Table | Column | Null Count | Interpretation |
|---|---|---:|---|
| Subscriptions | `end_date` | 4,514 | Expected. Approximately 90% of subscriptions are still active, so they have no end date. |
| Support Tickets | `closed_at` | 0 | Every support ticket has been resolved in this dataset. This means there are no open tickets to account for in downstream analytics. |
| Support Tickets | `satisfaction_score` | 825 | Expected. Not every customer completed the post-support survey. |
| Churn Events | `feedback_text` | 148 | Expected. Customer feedback was optional. |

Every support ticket is closed. The README didn't explicitly state this would be the case—it only defined the closed_at field. 

This tells us something about the dataset:
- It represents historical support activity rather than a live operational system with open tickets.
