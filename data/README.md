# Source Data

The source data used in this project is a synthetic SaaS dataset containing operational data across five business domains:

- Accounts
- Subscriptions
- Feature Usage
- Support Tickets
- Churn Events

The dataset contains 33,100 total records and was used to simulate an end-to-end analytics engineering workflow.

Raw source files are not stored directly in this repository. The PostgreSQL table definitions, ingestion structure, data quality validation, and downstream transformations are documented throughout the `/sql` and `/docs` directories.

## Dataset Structure

| Dataset | Records |
| --- | ---: |
| Accounts | 500 |
| Subscriptions | 5,000 |
| Feature Usage | 25,000 |
| Support Tickets | 2,000 |
| Churn Events | 600 |
| **Total** | **33,100** |

## Dataset Source

This project uses the publicly available **SaaS Subscription & Churn Analytics Dataset** published by **Rivalytics** on Kaggle.

Dataset:  
https://www.kaggle.com/datasets/rivalytics/saas-subscription-and-churn-analytics-dataset

The dataset is synthetic and serves as the source data for this analytics engineering portfolio project. All downstream PostgreSQL database design, data quality validation, transformation logic, analytical modeling, KPI definitions, and reporting marts were developed as part of the project.

## Related Documentation

See [`../docs/03_data_model.md`](../docs/03_data_model.md) for the source data model and relationships.

See [`../docs/04_raw_data_layer.md`](../docs/04_raw_data_layer.md) for raw-layer implementation details.

See [`../docs/05_data_validation.md`](../docs/05_data_validation.md) for source data quality findings and validation.
