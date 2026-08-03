# Raw Data Validation

## Purpose

Following ingestion into the `raw` schema, each source table was validated to ensure the data was structurally sound before any transformations were applied.

Validation focused on:

- Row count verification
- Primary key validation
- Referential integrity
- Null value profiling
- Business rule validation

The purpose of this phase was to establish confidence in the raw data while documenting any known source data issues prior to building the staging layer.

---

# Row Count Validation

| Table | Row Count |
|---|---:|
| accounts | 500 |
| subscriptions | 5,000 |
| feature_usage | 25,000 |
| support_tickets | 2,000 |
| churn_events | 600 |

**Result**

All source files were successfully ingested into the raw schema with expected row counts.

---

# Primary Key Validation

| Table | Expected Primary Key | Duplicate Records | Result |
|--------|----------------------|------------------:|--------|
| Accounts | `account_id` | 0 | ✅ Passed |
| Subscriptions | `subscription_id` | 0 | ✅ Passed |
| Feature Usage | `usage_id*` | 21 | ⚠️ Source Data Issue |
| Support Tickets | `ticket_id` | 0 | ✅ Passed |
| Churn Events | `churn_event_id` | 0 | ✅ Passed |

### Feature Usage

Although the dataset documentation describes `usage_id` as a unique usage event identifier, 21 duplicate values were identified during ingestion.

To preserve source fidelity:

- the primary key constraint was removed;
- a surrogate key (`raw_usage_row_id`) was introduced;
- duplicate investigation was deferred to downstream validation.

---

# Referential Integrity Validation

| Relationship | Orphaned Records | Result |
|---|---:|---|
| Subscriptions → Accounts | 0 | ✅ Passed |
| Feature Usage → Subscriptions | 0 | ✅ Passed |
| Support Tickets → Accounts | 0 | ✅ Passed |
| Churn Events → Accounts | 0 | ✅ Passed |

**Result**

All foreign key relationships successfully referenced valid parent records. No orphaned records were identified.

---

# Null Value Profiling

| Table | Column | Null Count | Expected? | Notes |
|---|---|---:|---|---|
| Subscriptions | `end_date` | 4,514 | Yes | Active subscriptions may not have an end date |
| Support Tickets | `closed_at` | 0 | N/A | All support tickets are resolved |
| Support Tickets | `satisfaction_score` | 825 | Yes | Customer survey not completed |
| Churn Events | `feedback_text` | 148 | Yes | Customer feedback is optional |

---

# Null Value Interpretation

| Table | Column | Interpretation |
|---|---|---|
| Subscriptions | `end_date` | Approximately 90% of subscriptions remain active and therefore do not contain an end date. |
| Support Tickets | `closed_at` | Every support ticket has been resolved, indicating the dataset represents historical support activity rather than live operational data. |
| Support Tickets | `satisfaction_score` | Null values indicate customers who did not submit a satisfaction survey. |
| Churn Events | `feedback_text` | Customer feedback is optional and is therefore expected to contain null values. |

---

# Business Rule Validation

The following business rules were evaluated to confirm that the source data behaves as expected.

| Validation | Invalid Records | Result |
|------------|---------------:|--------|
| ARR = MRR × 12 | 0 | ✅ Passed |
| End Date ≥ Start Date | 0 | ✅ Passed |
| Churned Subscription Has End Date | 0 | ✅ Passed |
| Active Subscription Has Null End Date | 0 | ✅ Passed |
| Negative Revenue | 0 | ✅ Passed |
| Positive Seat Count | 0 | ✅ Passed |

---

# Validation Summary

Overall, the raw dataset demonstrated strong structural integrity.

Validation confirmed:

- All source files were successfully ingested.
- All expected row counts were present.
- Referential integrity was maintained across all documented relationships.
- Business rule validation passed without identifying invalid records.
- Expected null values aligned with business expectations.
- One documented source data issue (`usage_id` duplicates) was identified and preserved without modifying the source data.

Based on these findings, the raw layer is considered suitable for downstream transformation within the staging layer.
