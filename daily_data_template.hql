-- Should these daily tables have all time data?

DROP TABLE IF EXISTS ndtallant_daily_data_ak;
CREATE EXTERNAL TABLE ndtallant_daily_data_ak AS
SELECT
  p_date,
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
     AND state = 'AK'
   GROUP BY p_date
) AS p JOIN (
  SELECT w_date,
         sum(discharge) AS discharge, 
         count(1) AS n_discharge 
    FROM ndtallant_ak 
   GROUP BY w_date 
) AS w ON p.p_date = w.w_date;
