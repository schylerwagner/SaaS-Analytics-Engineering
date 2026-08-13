-- Raw layer table definitions
-- Purpose: preserve source data with minimal transformation
-- before downstream validation and staging.

CREATE SCHEMA IF NOT EXISTS raw;

DROP TABLE IF EXISTS raw.feature_usage;
DROP TABLE IF EXISTS raw.support_tickets;
DROP TABLE IF EXISTS raw.churn_events;
DROP TABLE IF EXISTS raw.subscriptions;
DROP TABLE IF EXISTS raw.accounts;


-- =========================================================
-- Accounts
-- Grain: one row per account
-- =========================================================

CREATE TABLE raw.accounts (
    account_id TEXT PRIMARY KEY,
    account_name TEXT,
    industry TEXT,
    country TEXT,
    signup_date DATE,
    referral_source TEXT,
    plan_tier TEXT,
    seats INTEGER,
    is_trial BOOLEAN,
    churn_flag BOOLEAN
);


-- =========================================================
-- Subscriptions
-- Grain: one row per subscription
-- =========================================================

CREATE TABLE raw.subscriptions (
    subscription_id TEXT PRIMARY KEY,
    account_id TEXT,
    start_date DATE,
    end_date DATE,
    plan_tier TEXT,
    seats INTEGER,
    mrr_amount FLOAT,
    arr_amount FLOAT,
    is_trial BOOLEAN,
    upgrade_flag BOOLEAN,
    downgrade_flag BOOLEAN,
    churn_flag BOOLEAN,
    billing_frequency TEXT,
    auto_renew_flag BOOLEAN
);


-- =========================================================
-- Feature Usage
-- Grain: one row per source record
--
-- The source usage_id contains duplicate values.
-- A technical row identifier is therefore used as the
-- physical primary key while usage_id is retained for
-- source traceability.
-- =========================================================

CREATE TABLE raw.feature_usage (
    raw_usage_row_id BIGSERIAL PRIMARY KEY,
    usage_id TEXT,
    subscription_id TEXT,
    usage_date DATE,
    feature_name TEXT,
    usage_count INTEGER,
    usage_duration_secs INTEGER,
    error_count INTEGER,
    is_beta_feature BOOLEAN
);


-- =========================================================
-- Support Tickets
-- Grain: one row per support ticket
--
-- satisfaction_score is stored numerically because the
-- source CSV contains values such as 4.0.
-- =========================================================

CREATE TABLE raw.support_tickets (
    ticket_id TEXT PRIMARY KEY,
    account_id TEXT,
    submitted_at TIMESTAMP,
    closed_at TIMESTAMP,
    resolution_time_hours NUMERIC,
    priority TEXT,
    first_response_time_minutes INTEGER,
    satisfaction_score NUMERIC(3,1),
    escalation_flag BOOLEAN
);


-- =========================================================
-- Churn Events
-- Grain: one row per churn event
-- =========================================================

CREATE TABLE raw.churn_events (
    churn_event_id TEXT PRIMARY KEY,
    account_id TEXT,
    churn_date DATE,
    reason_code TEXT,
    refund_amount_usd NUMERIC,
    preceding_upgrade_flag BOOLEAN,
    preceding_downgrade_flag BOOLEAN,
    is_reactivation BOOLEAN,
    feedback_text TEXT
);
