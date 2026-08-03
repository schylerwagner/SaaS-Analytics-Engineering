# Logical Data Model

## Overview

The RavenStack SaaS dataset models the core operational entities involved in managing customer subscriptions, product usage, customer support, and churn events. The relational model captures the relationships between these business processes while maintaining normalized transactional data suitable for downstream analytical modeling.

This document defines the logical data model used throughout the project, including table grain, primary and foreign keys, relationship cardinality, and modeling considerations.

---

# Table Overview

## Accounts

**Grain**

One row per unique account.

**Primary Key**

`account_id`

**Role**

Core business entity representing a customer.

**Relationships**

- One account → many subscriptions
- One account → many support tickets
- One account → zero or more churn events

---

## Subscriptions

**Grain**

One row per unique subscription.

**Primary Key**

`subscription_id`

**Foreign Key**

`account_id` → Accounts

**Role**

Revenue-generating entity tied to a customer.

**Relationships**

- Many subscriptions → one account
- One subscription → many feature usage events

**Dataset Note**

Although subscriptions contain a `churn_flag`, the dataset models detailed churn history separately through the `churn_events` table at the account level.

---

## Feature Usage

**Grain**

One row per source record in `feature_usage.csv`.

**Primary Key**

`raw_usage_row_id` (surrogate key)

**Business Identifier**

`usage_id`

**Foreign Key**

`subscription_id` → Subscriptions

**Role**

Behavioral telemetry capturing customer engagement with the SaaS platform.

**Relationships**

- Many usage events → one subscription

---

## Support Tickets

**Grain**

One row per unique support ticket.

**Primary Key**

`ticket_id`

**Foreign Key**

`account_id` → Accounts

**Role**

Customer support interactions and service quality metrics.

**Relationships**

- Many support tickets → one account

---

## Churn Events

**Grain**

One row per unique churn event.

**Primary Key**

`churn_event_id`

**Foreign Key**

`account_id` → Accounts

**Role**

Records churn events associated with an account, including churn timing, reason, financial impact, and reactivation history.

**Relationships**

- Many churn events → one account

---

# Relationship Summary

| Parent | Child | Cardinality |
|---------|-------|------------|
| Accounts | Subscriptions | One-to-Many |
| Accounts | Support Tickets | One-to-Many |
| Accounts | Churn Events | One-to-Zero-or-Many |
| Subscriptions | Feature Usage | One-to-Many |

---

# Modeling Considerations

## Churn Modeling

During the initial modeling phase, an alternative design was considered where churn would be represented at the subscription level. Since subscriptions already contain lifecycle attributes (`start_date`, `end_date`, and `churn_flag`), this approach would accurately represent individual subscription lifecycles.

However, the source dataset intentionally models detailed churn history at the account level through the `churn_events` table. To preserve source fidelity and maintain consistency with the published schema, this project retains the dataset's original relational design.

---

## Feature Usage Identifier

During raw data ingestion, duplicate values were identified in the source `usage_id` field despite the dataset documentation describing it as unique.

To preserve every source record:

- the original `usage_id` was retained as a business identifier;
- a surrogate key (`raw_usage_row_id`) was introduced within PostgreSQL;
- duplicate investigation was documented as part of the raw data validation process.

---

# Future Enhancements

Future phases of this project will extend the logical model into:

- Staging models
- Analytical fact tables
- Dimension tables
- Star schema design
