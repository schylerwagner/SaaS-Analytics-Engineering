# SaaS Analytics Engineering Project (PostgreSQL)

## Project Overview

This project simulates an end-to-end Analytics Engineering workflow using PostgreSQL. The objective is to transform raw SaaS operational data into trusted, business-ready analytical models that support reporting, business intelligence, and decision-making.

Rather than focusing solely on SQL development, this project emphasizes the complete analytics engineering lifecycle, including data modeling, data validation, transformation, documentation, and repository organization.

---

## Business Objective

The project models a fictional SaaS company's operational data to answer common business questions related to:

- Customer growth
- Subscription lifecycle
- Product engagement
- Customer support performance
- Customer churn
- Revenue analytics

The final deliverable will be a structured analytics layer capable of supporting executive dashboards and ad-hoc business analysis.

---

## Technology Stack

- PostgreSQL
- SQL
- Git & GitHub
- Markdown Documentation

Future Enhancements

- Power BI or Tableau
- Python (data automation)
- dbt-inspired modeling practices

---

## Project Architecture

```text
CSV Files
     │
     ▼
raw
     │
     ▼
staging
     │
     ▼
analytics
     │
     ├── Dimensions
     ├── Fact Tables
     └── Executive Summary Mart
             │
             ▼
      Reporting / Dashboards
```

---

## Repository Structure

```
docs/
    Project documentation

sql/
    Raw table creation
    Validation queries
    Staging transformations
    Analytics models

images/
    Data models and architecture diagrams

data/
    Source datasets
```

---

## Current Progress

### Completed

- Business understanding
- Data model design
- Raw layer implementation
- Data quality validation
- Staging layer implementation
- Analytics dimensions and fact tables
- Executive summary mart
- SQL project organization
- Technical documentation

### Planned / Optional

- Executive dashboard or visualization
- Architecture and data model diagrams
- Additional analytical drill-downs

---

## Documentation

Detailed project documentation can be found in the `/docs` directory.

| Document | Description |
|----------|-------------|
| 01 | Project Overview |
| 02 | Business Understanding |
| 03 | Data Model |
| 04 | Raw Data Layer |
| 05 | Data Validation |
| 06 | Staging Layer |
| 07 | Analytics Layer |

---

## Learning Objectives

This project is designed to demonstrate practical Analytics Engineering skills, including:

- Relational data modeling
- Data warehouse design
- SQL development
- Data validation
- Data transformation
- Documentation
- Version control using GitHub

---

## Project Status

**Current Phase:** Analytics Layer Complete

The raw, staging, and analytics layers have been implemented and validated. The project now contains reusable dimensions, fact tables, and a monthly executive summary mart supporting customer, subscription, churn, product usage, support, and recurring revenue analysis.

The remaining work is optional presentation-layer enhancement, such as a lightweight executive dashboard and architecture diagrams.
