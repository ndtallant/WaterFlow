-- Should these daily tables have all time data?

SELECT
  p_date,
  sum(val) AS precip,
  count(1) AS n_precip
FROM ndtallant_p2019
WHERE element = 'PRCP'
  AND state = 'AK'
GROUP BY p_date
LIMIT 10;

SELECT 
  w_date,
  sum(discharge) AS discharge, 
  count(1) AS n_discharge 
FROM ndtallant_ak 
GROUP BY w_date 
LIMIT 10;
