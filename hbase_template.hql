INSERT INTO TABLE ndtallant_serve_daily
SELECT 
  CONCAT('{{STATE}}-', p_date),
  p_week,
  precip,
  n_precip,
  discharge,
  n_discharge
FROM ndtallant_daily_data_{{STATE}};
