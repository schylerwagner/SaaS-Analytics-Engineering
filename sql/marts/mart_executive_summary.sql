-- Executive summary mart
-- Grain: one row per calendar month.
-- Combines customer, churn, subscription, engagement,
-- support, and recurring revenue KPIs.

DROP TABLE IF EXISTS analytics.mart_executive_summary;


CREATE TABLE analytics.mart_executive_summary AS

WITH months AS (

    SELECT
        year_month,
        MIN(calendar_date) AS month_start,
        MAX(calendar_date) AS month_end,
        MIN(year) AS year,
        MIN(quarter) AS quarter,
        MIN(month_number) AS month_number
    FROM analytics.dim_date
    GROUP BY year_month
),


-- Customer population metrics
customer_metrics AS (

    SELECT
        m.year_month,

        COUNT(DISTINCT CASE
            WHEN s.start_date <= m.month_end
             AND (
                  s.end_date IS NULL
                  OR s.end_date >= m.month_end
             )
            THEN s.account_id
        END) AS month_end_active_customers,

        COUNT(DISTINCT CASE
            WHEN a.signup_date BETWEEN m.month_start AND m.month_end
            THEN a.account_id
        END) AS new_accounts

    FROM months m

    LEFT JOIN analytics.dim_subscription s
        ON s.start_date <= m.month_end

    LEFT JOIN analytics.dim_account a
        ON a.signup_date BETWEEN m.month_start AND m.month_end

    GROUP BY m.year_month
),


-- Account-level churn activity
churn_activity AS (

    SELECT
        m.year_month,
        COUNT(DISTINCT fc.account_id) AS accounts_with_churn_activity

    FROM months m

    LEFT JOIN analytics.fact_churn fc
        ON fc.churn_date BETWEEN m.month_start AND m.month_end

    GROUP BY m.year_month
),


-- Subscription lifecycle metrics
subscription_metrics AS (

    SELECT
        m.year_month,

        COUNT(DISTINCT CASE
            WHEN s.start_date <= m.month_start
             AND (
                  s.end_date IS NULL
                  OR s.end_date >= m.month_start
             )
            THEN s.subscription_id
        END) AS beginning_active_subscriptions,

        COUNT(DISTINCT CASE
            WHEN s.churn_flag = TRUE
             AND s.end_date BETWEEN m.month_start AND m.month_end
            THEN s.subscription_id
        END) AS churned_subscriptions,

        COUNT(DISTINCT CASE
            WHEN s.is_trial = TRUE
             AND s.start_date BETWEEN m.month_start AND m.month_end
            THEN s.subscription_id
        END) AS new_trial_subscriptions

    FROM months m

    LEFT JOIN analytics.dim_subscription s
        ON s.start_date <= m.month_end

    GROUP BY m.year_month
),


-- Daily product engagement
daily_usage AS (

    SELECT
        usage_date,
        SUM(usage_count) AS daily_usage_count,
        SUM(usage_duration_secs) AS daily_usage_duration_secs
    FROM analytics.fact_feature_usage
    GROUP BY usage_date
),


usage_metrics AS (

    SELECT
        m.year_month,

        ROUND(
            AVG(COALESCE(du.daily_usage_count, 0)),
            2
        ) AS avg_daily_usage_count,

        ROUND(
            AVG(COALESCE(du.daily_usage_duration_secs, 0)) / 3600.0,
            2
        ) AS avg_daily_usage_hours

    FROM months m

    JOIN analytics.dim_date d
        ON d.calendar_date BETWEEN m.month_start AND m.month_end

    LEFT JOIN daily_usage du
        ON du.usage_date = d.calendar_date

    GROUP BY m.year_month
),


-- Customer support metrics
support_metrics AS (

    SELECT
        m.year_month,

        ROUND(
            AVG(st.resolution_time_hours),
            2
        ) AS avg_resolution_time_hours,

        ROUND(
            AVG(st.satisfaction_score),
            2
        ) AS avg_satisfaction_score

    FROM months m

    LEFT JOIN analytics.fact_support_tickets st
        ON CAST(st.closed_at AS DATE)
           BETWEEN m.month_start AND m.month_end

    GROUP BY m.year_month
),


-- Recurring revenue metrics
revenue_metrics AS (

    SELECT
        m.year_month,

        ROUND(
            SUM(
                CASE
                    WHEN r.start_date <= m.month_end
                     AND (
                          r.end_date IS NULL
                          OR r.end_date >= m.month_end
                     )
                    THEN r.mrr_amount
                    ELSE 0
                END
            ),
            2
        ) AS month_end_mrr,

        ROUND(
            SUM(
                CASE
                    WHEN r.start_date <= m.month_end
                     AND (
                          r.end_date IS NULL
                          OR r.end_date >= m.month_end
                     )
                    THEN r.arr_amount
                    ELSE 0
                END
            ),
            2
        ) AS month_end_arr,

        ROUND(
            SUM(
                CASE
                    WHEN r.start_date
                         BETWEEN m.month_start AND m.month_end
                    THEN r.mrr_amount
                    ELSE 0
                END
            ),
            2
        ) AS new_mrr,

        ROUND(
            SUM(
                CASE
                    WHEN s.churn_flag = TRUE
                     AND r.end_date
                         BETWEEN m.month_start AND m.month_end
                    THEN r.mrr_amount
                    ELSE 0
                END
            ),
            2
        ) AS churned_mrr

    FROM months m

    LEFT JOIN analytics.fact_subscription_revenue r
        ON r.start_date <= m.month_end

    LEFT JOIN analytics.dim_subscription s
        ON r.subscription_id = s.subscription_id

    GROUP BY m.year_month
)


SELECT
    m.month_start,
    m.month_end,
    m.year_month,
    m.year,
    m.quarter,
    m.month_number,

    cm.month_end_active_customers,
    cm.new_accounts,

    ca.accounts_with_churn_activity,

    sm.beginning_active_subscriptions,
    sm.churned_subscriptions,

    ROUND(
        CAST(sm.churned_subscriptions AS NUMERIC)
        /
        NULLIF(sm.beginning_active_subscriptions, 0)
        * 100,
        2
    ) AS subscription_churn_rate_pct,

    sm.new_trial_subscriptions,

    um.avg_daily_usage_count,
    um.avg_daily_usage_hours,

    sp.avg_resolution_time_hours,
    sp.avg_satisfaction_score,

    rm.month_end_mrr,
    rm.month_end_arr,
    rm.new_mrr,
    rm.churned_mrr

FROM months m

LEFT JOIN customer_metrics cm
    ON m.year_month = cm.year_month

LEFT JOIN churn_activity ca
    ON m.year_month = ca.year_month

LEFT JOIN subscription_metrics sm
    ON m.year_month = sm.year_month

LEFT JOIN usage_metrics um
    ON m.year_month = um.year_month

LEFT JOIN support_metrics sp
    ON m.year_month = sp.year_month

LEFT JOIN revenue_metrics rm
    ON m.year_month = rm.year_month

ORDER BY m.month_start;


ALTER TABLE analytics.mart_executive_summary
ADD CONSTRAINT analytics_mart_executive_summary_pkey
PRIMARY KEY (month_start);
