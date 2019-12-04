DROP TABLE IF EXISTS ndtallant_serve_daily;
CREATE EXTERNAL TABLE ndtallant_serve_daily (
  state_date STRING,
  p_week BIGINT,
  precip BIGINT,
  n_precip BIGINT,
  discharge DOUBLE,
  n_discharge BIGINT
)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key,water:p_week,water:precip,water:n_precip,water:discharge,water:n_discharge')
TBLPROPERTIES ('hbase.table.name' = 'ndtallant_serve_daily');
