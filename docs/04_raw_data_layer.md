# Raw Data Layer

## Purpose

The raw layer serves as the initial landing zone for source data within the PostgreSQL database.

Its primary purpose is to preserve the source data as closely as possible while applying only the minimum structural requirements needed for storage, such as PostgreSQL data types and primary keys where appropriate.

No business logic, aggregations, filtering, or analytical transformations are performed within the raw layer.

---

# Database

**Database**

`saas_churn_analytics`

**Schema**

`raw`

---

# Source Data

The project ingests five source CSV files representing operational SaaS business data.

| Source File | Destination Table |
| --- | --- |
| accounts.csv | raw.accounts |
| subscriptions.csv | raw.subscriptions |
| feature_usage.csv | raw.feature_usage |
| support_tickets.csv | raw.support_tickets |
| churn_events.csv | raw.churn_events |

---

# Raw Table Definitions

## raw.accounts

**Source**

accounts.csv

**Grain**

One row per unique account.

**Primary Key**

`account_id`

**Purpose**

Stores the core customer account information.

---

## raw.subscriptions

**Source**

subscriptions.csv

**Grain**

One row per unique subscription.

**Primary Key**

`subscription_id`

**Purpose**

Stores subscription lifecycle and recurring revenue information.

---

## raw.feature_usage

**Source**

feature_usage.csv

**Grain**

One row per source record.

**Primary Key**

`raw_usage_row_id`

**Business Identifier**

`usage_id`

**Purpose**

Stores feature-level customer usage events.

---

## raw.support_tickets

**Source**

support_tickets.csv

**Grain**

One row per support ticket.

**Primary Key**

`ticket_id`

**Purpose**

Stores customer support interactions and service metrics.

---

## raw.churn_events

**Source**

churn_events.csv

**Grain**

One row per churn event.

**Primary Key**

`churn_event_id`

**Purpose**

Stores customer churn events and related business context.

---

# PostgreSQL Data Type Decisions

Several PostgreSQL data types were selected to preserve the source representation while supporting downstream analytical workloads.

Examples include:

- `TEXT` for identifiers and categorical values
- `DATE` for business dates
- `TIMESTAMP` for event timestamps
- `BOOLEAN` for binary indicators
- `INTEGER` for counts
- Floating-point or numeric types where required to preserve the source representation

For recurring revenue fields such as `mrr_amount` and `arr_amount`, the raw layer retained the source-oriented numeric implementation used during ingestion.

In a production financial model, exact `NUMERIC` / `DECIMAL` types would generally be preferred over floating-point types for currency to avoid potential precision issues.

---

# Known Source Data Issues

## Feature Usage

During ingestion, duplicate values were identified in the source `usage_id` column despite the dataset documentation describing the field as unique.

To preserve every source record:

- the primary key constraint on `usage_id` was removed;
- a surrogate key (`raw_usage_row_id`) was introduced;
- the original `usage_id` was retained as a source business identifier.

---

## Support Tickets

The dataset documentation describes `satisfaction_score` as an integer rating.

During ingestion, the source CSV stored values using decimal formatting, for example `4.0`.

To preserve source fidelity, the raw PostgreSQL column was defined using a numeric representation compatible with the source values rather than forcing an integer conversion during ingestion.

---

# Raw Layer Design Principles

The raw layer follows several core design principles throughout this project:

- Preserve source data without business transformations.
- Match PostgreSQL data types to the source representation.
- Document source inconsistencies rather than silently correcting them.
- Apply data validation before enforcing downstream business rules.
- Maintain traceability between source files and database tables.
