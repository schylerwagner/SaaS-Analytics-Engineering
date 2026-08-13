# Business Understanding

## Project Objective

Design and implement an end-to-end analytics engineering solution that transforms operational SaaS data into a structured, analytics-ready data model.

The project simulates the early phases of a modern data warehouse by ingesting raw business data, validating data quality, applying standardized transformations, and preparing the data for downstream reporting and analytical use.

---

## Business Overview

RavenStack is a fictional Software-as-a-Service (SaaS) company that provides subscription-based software products to business customers.

As customers interact with the platform, operational data is generated across several business processes, including:

- Customer account management
- Subscription lifecycle management
- Product feature usage
- Customer support interactions
- Customer churn and retention

This operational data supports business functions such as Customer Success, Product Management, Finance, and Executive Leadership.

---

## Business Problem

Operational data is distributed across multiple business entities and is not immediately suitable for analytics or reporting.

To generate reliable business insights, the data must first be:

- Organized into a relational structure
- Validated for quality and consistency
- Standardized through transformation
- Prepared for downstream analytical modeling

Without these steps, reporting may produce inconsistent metrics, inaccurate business insights, and conflicting interpretations of key performance indicators.

---

## Business Objectives

This project aims to support several common SaaS business objectives:

- Understand customer retention and churn
- Measure subscription performance and recurring revenue
- Analyze customer engagement with product features
- Evaluate customer support activity and service quality
- Build a trusted analytical foundation for business reporting

---

## Key Business Questions

The completed analytical model should enable business users to answer questions such as:

- How many active customers does the company currently have?
- Which subscription plans generate the most recurring revenue?
- Which product features are most frequently used?
- What characteristics are common among accounts experiencing churn activity or churned subscriptions?
- How does customer engagement relate to churn?
- What trends exist in customer support activity?
- Which customer segments demonstrate the highest long-term value?

---

## Business Definitions

### Customer

A business account that purchases and uses the RavenStack SaaS platform.

---

### Active Customer

An account with at least one active subscription.

An active subscription generally satisfies:

- `end_date IS NULL`
- `churn_flag = FALSE`

---

### Subscription

A contractual agreement between a customer and the SaaS platform defining service level, billing information, and subscription lifecycle.

---

### Churn

Churn represents the termination of an individual subscription lifecycle or churn-related activity associated with an account.

The dataset captures churn in two complementary ways:

- `subscriptions.churn_flag` and `end_date` represent subscription-level lifecycle termination.
- `churn_events` captures additional account-level churn context, including churn date, reason, refund amount, preceding upgrade/downgrade activity, reactivation indicators, and customer feedback.

A churn event should not automatically be interpreted as the complete loss of a customer because an account may maintain other active subscriptions or later reactivate.

For this reason, downstream analytics distinguish between:

- Accounts with churn activity
- Churned subscriptions
- Subscription churn rate

---

### Engagement

Customer interaction with the SaaS platform measured through product usage.

Examples include:

- Feature usage frequency
- Usage duration
- Feature adoption
- Beta feature participation
- Application error counts

These metrics may be used to evaluate customer health, product adoption, and churn risk.

---

### Customer Support

Interactions between customers and the support organization, including ticket volume, response times, resolution times, customer satisfaction, and escalation activity.

---

## Business Assumptions

The project is based on the following assumptions:

- The provided dataset represents historical operational data from a SaaS business.
- Each table represents a distinct business process.
- Source data is preserved within the raw layer before transformations are applied.
- Business metrics are derived from validated and standardized data rather than directly from raw operational records.
