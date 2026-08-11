-- This dimension provides a standardized calendar
-- for time-based reporting and analytical aggregation.

DROP TABLE IF EXISTS analytics.dim_date;

CREATE TABLE analytics.dim_date AS
SELECT
    generated_date::DATE AS calendar_date,
    EXTRACT(YEAR FROM generated_date)::INTEGER AS year,
    EXTRACT(QUARTER FROM generated_date)::INTEGER AS quarter,
    EXTRACT(MONTH FROM generated_date)::INTEGER AS month_number,
    TO_CHAR(generated_date, 'FMMonth') AS month_name,
    TO_CHAR(generated_date, 'YYYY-MM') AS year_month,
    EXTRACT(DAY FROM generated_date)::INTEGER AS day_of_month,
    EXTRACT(ISODOW FROM generated_date)::INTEGER AS day_of_week_number,
    TO_CHAR(generated_date, 'FMDay') AS day_of_week_name
FROM GENERATE_SERIES(
    DATE '2023-01-01',
    DATE '2024-12-31',
    INTERVAL '1 day'
) AS dates(generated_date);

ALTER TABLE analytics.dim_date
ADD CONSTRAINT analytics_dim_date_pkey
PRIMARY KEY (calendar_date);
