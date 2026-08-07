# Staging Layer

## Purpose

The staging layer prepares validated raw data for downstream analytical modeling.

Unlike the raw layer, which preserves source data in its original form, the staging layer applies lightweight, non-destructive transformations that improve consistency while preserving the grain of each source table.

The staging layer serves as the foundation for the analytics layer by providing standardized, trusted datasets that are easier to join and consume.

---

## Design Principles

The staging layer follows several core design principles:

- Preserve the grain of each source table.
- Maintain one-to-one traceability back to the raw layer.
- Apply lightweight standardization and data cleansing.
- Avoid aggregations and business metrics.
- Prepare data for downstream analytical modeling.

---

# Staging Tables

## staging.accounts

### Source

`raw.accounts`

### Grain

One row per account.

### Primary Key

`account_id`

### Standardization & Transformations

- Trimmed whitespace from text fields.
- Standardized `country` to uppercase.
- Standardized `referral_source` to lowercase.
- Standardized `plan_tier` using proper case.
- Added `account_tenure_years`.

### Validation

- Source row count: **500**
- Staging row count: **500**
- Duplicate `account_id` values: **0**

### Notes

The grain of the source table was preserved while applying lightweight standardization and a single derived attribute for downstream analytical use.

## staging.subscriptions

### Source

`raw.subscriptions`

### Grain

One row per subscription.

### Primary Key

`subscription_id`

### Foreign Key

`account_id`

### Standardization & Transformations

- Standardized `plan_tier` using proper case.
- Standardized `billing_frequency` to lowercase.
- Added `subscription_status`.

### Validation

- Source rows: 5,000
- Staging rows: 5,000
- Duplicate `subscription_id`: 0
- Invalid `subscription_status`: 0

### Notes

The staging model standardizes subscription lifecycle information while preserving one record per subscription.

## staging.feature_usage

### Source

`raw.feature_usage`

### Grain

One row per usage event.

### Primary Key

`raw_usage_row_id`

### Foreign Key

`subscription_id`

### Standardization & Transformations

- Trimmed whitespace from `feature_name`.
- Preserved `usage_id` as the source business identifier.

### Validation

- Source rows: 25,000
- Staging rows: 25,000
- Duplicate surrogate keys: 0
- Orphaned subscriptions: 0

### Notes

A surrogate key was retained to uniquely identify every source record while preserving the original `usage_id` for traceability.

## staging.support_tickets

### Source

`raw.support_tickets`

### Grain

One row per support ticket.

### Primary Key

`ticket_id`

### Foreign Key

`account_id`

### Standardization & Transformations

- Standardized `priority` to lowercase.
- Converted `satisfaction_score` to integer.
- Added `ticket_status`.

### Validation

- Source rows: 2,000
- Staging rows: 2,000
- Duplicate `ticket_id`: 0
- Invalid satisfaction scores: 0

### Notes

The staging model standardizes support attributes while preserving ticket-level detail.

## staging.churn_events

### Source

`raw.churn_events`

### Grain

One row per churn event.

### Primary Key

`churn_event_id`

### Foreign Key

`account_id`

### Standardization & Transformations

- Standardized `reason_code` to lowercase.
- Trimmed whitespace from `feedback_text`.

### Validation

- Source rows: 600
- Staging rows: 600
- Duplicate `churn_event_id`: 0
- Orphaned accounts: 0

### Notes

The staging model preserves churn history while applying lightweight text standardization.
