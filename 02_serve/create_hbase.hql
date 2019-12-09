DROP TABLE IF EXISTS ndtallant_serve_daily;
CREATE EXTERNAL TABLE ndtallant_serve_daily (
  state_date STRING,
  p_week BIGINT,
  p_month BIGINT,
  p_year BIGINT,
  precip BIGINT,
  n_precip BIGINT,
  discharge DOUBLE,
  n_discharge BIGINT
)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key,water:p_week,water:p_month,water:p_year,water:precip,water:n_precip,water:discharge,water:n_discharge')
TBLPROPERTIES ('hbase.table.name' = 'ndtallant_serve_daily');

-- Weekly averages with the date of the beginning of that week.
DROP TABLE IF EXISTS ndtallant_serve_weekly;
CREATE EXTERNAL TABLE ndtallant_serve_weekly (
  state_week STRING,
  p_date BIGINT,
  precip BIGINT,
  n_precip BIGINT,
  discharge DOUBLE,
  n_discharge BIGINT
)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key,water:p_date,water:precip,water:n_precip,water:discharge,water:n_discharge')
TBLPROPERTIES ('hbase.table.name' = 'ndtallant_serve_weekly');

-- monthly averages with the date of the beginning of that month.
DROP TABLE IF EXISTS ndtallant_serve_monthly;
CREATE EXTERNAL TABLE ndtallant_serve_monthly (
  state_month STRING,
  precip BIGINT,
  n_precip BIGINT,
  discharge DOUBLE,
  n_discharge BIGINT
)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key,water:precip,water:n_precip,water:discharge,water:n_discharge')
TBLPROPERTIES ('hbase.table.name' = 'ndtallant_serve_monthly');
