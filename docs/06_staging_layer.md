# Staging Layer

## Purpose

The staging layer prepares validated raw data for downstream analytical modeling.

Unlike the raw layer, which preserves the source data as received, the staging layer applies lightweight, non-destructive transformations that improve data consistency while maintaining the original grain of each table.

The staging layer serves as the foundation for the analytics layer and ensures that downstream reporting is built from standardized, trusted data.

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

### Transformations

- Trimmed whitespace from text fields.
- Standardized `country` to uppercase.
- Standardized `referral_source` to lowercase.
- Standardized `plan_tier` using proper case.
- Added `account_tenure_years`.

### Validation

- Source row count: **500**
- Staging row count: **500**
- Duplicate `account_id` values: **0**

### Result

The grain of the source table was preserved while applying lightweight standardization and a single derived attribute for downstream analytical use.
