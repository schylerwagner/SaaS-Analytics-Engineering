# 01 — Project Overview

## Project Summary

The SaaS Analytics Engineering project simulates an end-to-end analytics engineering workflow using PostgreSQL. The project transforms synthetic SaaS operational data into validated, business-ready analytical models designed to support reporting, business intelligence, and executive analysis.

The workflow follows a layered architecture:

**Source Data → Raw → Staging → Analytics → Executive Mart**

The project emphasizes not only SQL transformation, but also data quality validation, business-rule development, dimensional modeling, KPI definition, documentation, and reproducible project organization.

---

## Project Objectives

The primary objectives of the project were to:

- Design a structured PostgreSQL environment for analytical workloads.
- Preserve source data in a raw layer before applying transformations.
- Profile and validate source data before downstream modeling.
- Standardize and prepare data through a staging layer.
- Develop reusable dimensions and fact tables.
- Define business metrics using validated source data.
- Build an executive-level analytical mart.
- Document technical decisions, data limitations, and validation findings.
- Organize the complete workflow in a version-controlled GitHub repository.

---

## Source Data

The project uses the synthetic **SaaS Subscription & Churn Analytics Dataset** published by Rivalytics on Kaggle.

The dataset contains five operational datasets:

| Dataset | Records |
| --- | ---: |
| Accounts | 500 |
| Subscriptions | 5,000 |
| Feature Usage | 25,000 |
| Support Tickets | 2,000 |
| Churn Events | 600 |
| **Total** | **33,100** |

The datasets represent customer attributes, subscription activity, product engagement, support interactions, and churn-related activity.

Source data details and attribution are documented in [`../data/README.md`](../data/README.md).

---

## Architecture

The PostgreSQL environment is organized into three primary schemas:

### Raw

Preserves source data in its original analytical structure and provides the starting point for data profiling and validation.

### Staging

Cleans, standardizes, validates, and prepares source data for downstream modeling.

### Analytics

Contains reusable dimensions, fact tables, and analytical outputs designed for reporting and business analysis.

The final workflow follows:

**CSV Source Data → Raw → Staging → Analytics Dimensions/Facts → Executive Summary Mart**

---

## Analytics Models

The analytics layer contains three dimensions:

- `dim_account`
- `dim_subscription`
- `dim_date`

And four primary fact models:

- `fact_feature_usage`
- `fact_support_tickets`
- `fact_churn`
- `fact_subscription_revenue`

These models provide reusable analytical structures across customer, subscription, product engagement, support, churn, and revenue domains.

---

## Executive Analytics Mart

The final reporting model is:

`mart_executive_summary`

The mart contains **one row per calendar month** from January 2023 through December 2024.

It consolidates validated KPIs across several business areas, including:

- Customer growth
- Subscription activity
- Subscription churn
- Product engagement
- Customer support performance
- MRR and ARR
- New MRR
- Churned MRR

This provides a single business-ready dataset that could serve as the source for an executive BI dashboard or recurring analytical reporting.

---

## Data Quality Approach

Data validation was treated as a distinct phase rather than being embedded only within transformation logic.

Validation included:

- Primary key uniqueness
- Foreign key integrity
- Null analysis
- Categorical consistency
- Numeric validation
- Temporal/date validation
- Business-rule validation
- Reconciliation of downstream metrics against source data

Validation findings directly influenced several modeling and KPI decisions.

For example, duplicate `usage_id` values were identified in the feature usage source data. Rather than incorrectly enforcing the source identifier as a primary key, the analytical model retained a separate unique row identifier while preserving `usage_id` as a source attribute.

---

## Repository Organization

The repository separates project components by purpose:

```text
data/
    Source data documentation

docs/
    Project methodology and technical documentation

images/
    Architecture and analytical data-model diagrams

sql/
    raw/
    staging/
    analytics/
    marts/
```

This structure allows the project methodology, SQL implementation, source documentation, and visual architecture to be reviewed independently while remaining part of the same workflow.

---

## Final Deliverable

The completed project provides a documented and validated analytics engineering pipeline that transforms operational SaaS data into reusable analytical models and an executive reporting mart.

The core analytics engineering workflow is complete. Potential future enhancements include a BI visualization layer, additional analytical drill-downs, Python-based automation, or implementation of the transformation workflow using dbt.
