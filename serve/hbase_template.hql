INSERT INTO TABLE ndtallant_serve_daily
SELECT 
  CONCAT('{{STATE}}-', p_date),
  p_week,
  p_month,
  p_year,
  precip,
  n_precip,
  discharge,
  n_discharge
FROM ndtallant_daily_data_{{STATE}};

INSERT INTO TABLE ndtallant_serve_weekly
SELECT
  CONCAT('{{STATE}}-', p_week, '-', p_year),
  min(p_date) as p_date,
  sum(precip) AS precip,
  sum(n_precip) AS n_precip,
  sum(discharge) AS discharge,
  sum(n_discharge) AS n_discharge
FROM ndtallant_daily_data_{{STATE}}
GROUP BY p_week, p_year;


INSERT INTO TABLE ndtallant_serve_monthly
SELECT
  CONCAT('{{STATE}}-', p_month, '-', p_year),
  sum(precip) AS precip,
  sum(n_precip) AS n_precip,
  sum(discharge) AS discharge,
  sum(n_discharge) AS n_discharge
FROM ndtallant_daily_data_{{STATE}}
GROUP BY p_month, p_year;
