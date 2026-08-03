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
| Accounts | account_id | | |
| Subscriptions | subscription_id | | |
| Feature Usage | usage_id* | | |
| Support Tickets | ticket_id | | |
| Churn Events | churn_event_id | | |
