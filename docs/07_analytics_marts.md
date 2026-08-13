# Analytics Marts

## Purpose

The analytics layer organizes validated staging data into business-ready dimensions, fact tables, and marts designed to support reporting and executive-level analysis.

The models in this layer are intentionally structured around business questions rather than source-system structure.

---

## Core Analytics Models

### Dimensions

- `analytics.dim_account`
  - Grain: one row per account
  - Purpose: customer segmentation and descriptive account attributes

- `analytics.dim_subscription`
  - Grain: one row per subscription
  - Purpose: subscription-level descriptive and lifecycle attributes

- `analytics.dim_date`
  - Grain: one row per calendar date
  - Purpose: standardized calendar for monthly, quarterly, and yearly reporting

### Fact Tables

- `analytics.fact_feature_usage`
  - Grain: one row per usage event
  - Purpose: product engagement analysis

- `analytics.fact_support_tickets`
  - Grain: one row per support ticket
  - Purpose: support performance and customer satisfaction analysis

- `analytics.fact_churn`
  - Grain: one row per churn event
  - Purpose: churn-event and retention analysis

- `analytics.fact_subscription_revenue`
  - Grain: one row per subscription
  - Purpose: recurring revenue analysis

---

## Executive Summary Mart

### Model

`analytics.mart_executive_summary`

### Grain

One row per calendar month.

Monthly grain was selected so that the mart can support executive trend reporting while allowing quarterly and yearly values to be derived from monthly results rather than storing redundant aggregates.

---

## KPI Definitions

### Month-End Active Customers

Number of distinct accounts with at least one subscription active on the final calendar day of the reporting month.

This is a snapshot metric and should not be summed across months.

---

### New Accounts

Number of unique accounts whose `signup_date` occurs during the reporting month.

This is a flow metric and can be aggregated across reporting periods.

---

### Accounts with Churn Activity

Number of distinct accounts with at least one churn event during the reporting month.

This metric represents churn activity within an account and should not be interpreted as customers fully lost from the business.

---

### Beginning Active Subscriptions

Number of subscriptions active at the beginning of the reporting month.

This metric provides the denominator used to calculate monthly Subscription Churn Rate.

---

### Churned Subscriptions

Number of subscriptions where `churn_flag = TRUE` and `end_date` occurs during the reporting month.

---

### Subscription Churn Rate

Number of subscriptions that churn during the reporting month divided by the number of subscriptions active at the beginning of the month.

January 2023 returns a null churn rate because there were no active subscriptions at the beginning of that month.

---

### New Trial Subscriptions

Number of subscriptions where `is_trial = TRUE` and `start_date` occurs during the reporting month.

This metric replaced the originally proposed Trial Conversion KPI because the dataset does not provide a reliable relationship between trial subscriptions and subsequent paid subscriptions.

---

### Average Daily Usage Count

Average total `usage_count` recorded per calendar day during the reporting month.

---

### Average Daily Usage Duration

Average total `usage_duration_secs` recorded per calendar day during the reporting month.

The executive mart exposes this metric as average daily usage hours for improved readability while preserving seconds in the underlying fact table.

---

### Average Resolution Time

Average `resolution_time_hours` for support tickets closed during the reporting month.

`closed_at` is used as the reporting date because the metric reflects completed support activity.

---

### Average Satisfaction Score

Average `satisfaction_score` for tickets closed during the reporting month.

Null satisfaction scores are excluded from the average because they represent customers who did not submit a survey response.

---

### Month-End MRR

Sum of `mrr_amount` for subscriptions active on the final calendar day of the reporting month.

---

### Month-End ARR

Sum of `arr_amount` for subscriptions active on the final calendar day of the reporting month.

---

### New MRR

Sum of `mrr_amount` associated with subscriptions whose `start_date` occurs during the reporting month.

---

### Churned MRR

Sum of `mrr_amount` associated with subscriptions where `churn_flag = TRUE` and `end_date` occurs during the reporting month.

---

## KPI Design Decisions

### Customer Churn vs. Subscription Churn

The original KPI concept was Customer Churn Rate.

During validation, accounts with churn events were found to still have active subscriptions. Because churn activity does not necessarily mean the customer relationship ended, Customer Churn Rate would be misleading.

The KPI was therefore refined to Subscription Churn Rate, where the numerator and denominator are measured at the same subscription grain.

---

### Trial Conversion

The original KPI concept was Trial Conversions.

Analysis showed that many accounts had paid subscriptions before trial subscriptions, and the source data does not provide an explicit trial-to-paid conversion relationship.

The metric was therefore replaced with New Trial Subscriptions.

---

### Upgrade/Downgrade Ratio

The dataset supports an overall upgrade-to-downgrade ratio, but it does not provide `upgrade_date` or `downgrade_date`.

Because the timing of these events cannot be determined, the ratio is excluded from the monthly executive mart.

The validated overall ratio is:

- Upgraded subscriptions: **529**
- Downgraded subscriptions: **218**
- Upgrade-to-downgrade ratio: **2.43**

---

## Source Data Limitations

The subscription dataset contains current subscription-level MRR and ARR values but does not provide a historical billing ledger or dated pricing-change history.

As a result:

- Month-End MRR and ARR use the available subscription-level recurring revenue values.
- New MRR is based on subscription start dates.
- Churned MRR is based on subscription end dates for churned subscriptions.
- Historical revenue changes caused by mid-cycle upgrades or downgrades cannot be reconstructed precisely.

These limitations are intentionally preserved rather than estimating unsupported historical values.

---

## Final Executive Summary Mart

### Model

`analytics.mart_executive_summary`

### Grain

One row per calendar month.

The mart contains **24 monthly records covering January 2023 through December 2024**.

### Included KPIs

- Month-End Active Customers
- New Accounts
- Accounts with Churn Activity
- Beginning Active Subscriptions
- Churned Subscriptions
- Subscription Churn Rate
- New Trial Subscriptions
- Average Daily Usage Count
- Average Daily Usage Hours
- Average Resolution Time
- Average Satisfaction Score
- Month-End MRR
- Month-End ARR
- New MRR
- Churned MRR

### Validation

The executive mart was validated against independently calculated KPI results before being considered complete.

Validation confirmed:

- **24** monthly records
- Unique month-level grain
- **500** total new accounts
- **486** total churned subscriptions
- **778** total new trial subscriptions
- **$1,179,139** total churned MRR
- No unexpected null values
- January 2023 Subscription Churn Rate is intentionally null because there were no active subscriptions at the beginning of the month

Final mart metrics were reconciled against independently calculated KPI results before the mart was considered ready for reporting use.

### Result

The analytics layer successfully consolidates customer, subscription, churn, product usage, support, and recurring revenue metrics into a business-ready monthly reporting model.

The mart can serve as the primary source for executive-level reporting while the underlying fact and dimension tables remain available for deeper analysis.
