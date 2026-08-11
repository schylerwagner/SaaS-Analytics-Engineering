-- This dimension provides a standardized calendar
-- for time-based reporting and analytical aggregation.

DROP TABLE IF EXISTS analytics.dim_date;

CREATE TABLE analytics.dim_date AS
SELECT
    calendar_date,
    EXTRACT(YEAR FROM calendar_date)::INTEGER AS year,
    EXTRACT(QUARTER FROM calendar_date)::INTEGER AS quarter,
    EXTRACT(MONTH FROM calendar_date)::INTEGER AS month_number,
    TO_CHAR(calendar_date, 'Month') AS month_name,
    TO_CHAR(calendar_date, 'YYYY-MM') AS year_month,
    EXTRACT(DAY FROM calendar_date)::INTEGER AS day_of_month,
    EXTRACT(ISODOW FROM calendar_date)::INTEGER AS day_of_week_number,
    TO_CHAR(calendar_date, 'Day') AS day_of_week_name
FROM GENERATE_SERIES(
    DATE '2023-01-01',
    DATE '2024-12-31',
    INTERVAL '1 day'
) AS dates(calendar_date);

ALTER TABLE analytics.dim_date
ADD CONSTRAINT analytics_dim_date_pkey
PRIMARY KEY (calendar_date);
