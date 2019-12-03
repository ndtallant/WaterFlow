-- Make sure source data exists in hdfs://ndtallant/project/water

DROP TABLE IF EXISTS ndtallant_{{STATE}};
CREATE EXTERNAL TABLE ndtallant_{{STATE}} (
  agency STRING,
  station STRING,          
  w_date DATE,
  discharge DOUBLE            
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = "\t"
)
STORED AS TEXTFILE
  location '/ndtallant/project/water/{{STATE}}';
