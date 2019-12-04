DROP TABLE IF EXISTS ndtallant_daily_data_{{STATE}};
CREATE EXTERNAL TABLE ndtallant_daily_data_{{STATE}} AS
SELECT
  p_date,
  weekofyear(p_date) AS p_week,
  month(p_date) AS p_month,
  year(p_date) AS p_year,
  precip,
  n_precip,
  discharge,
  n_discharge
FROM (
  SELECT p_date,
         sum(val) AS precip,
         count(1) AS n_precip
    FROM ndtallant_precipitation
   WHERE element = 'PRCP'
     AND state = '{{BIG_STATE}}'
   GROUP BY p_date
) AS p JOIN (
  SELECT w_date,
         sum(discharge) AS discharge, 
         count(1) AS n_discharge 
    FROM ndtallant_{{STATE}} 
   GROUP BY w_date 
) AS w ON p.p_date = w.w_date;
