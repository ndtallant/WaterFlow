-- Make sure source data exists in hdfs://ndtallant/project/precip

DROP TABLE IF EXISTS ndtallant_station_to_state;
CREATE EXTERNAL TABLE ndtallant_station_to_state (station STRING, state STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = " "
)
STORED AS TEXTFILE
  location '/ndtallant/project/precip/station_to_state';

-- id: 11 character id
-- date: YYYMMDD
-- element: 4 character indicator of element type 
-- val: 5 character data value for element 
-- -- These are not necessarily binary!
-- m-flag: 1 character measurement flag 
-- q-flag: 1 character quality flag 
-- s-flag: 1 character source flag 
-- obs-time: 4-character time of observation in hour-minute format (i.e. 0700 #7:00 am)

DROP TABLE IF EXISTS ndtallant_precipitation_csv;
CREATE EXTERNAL TABLE ndtallant_precipitation_csv (
  id CHAR(11),
  p_date DATE,
  element CHAR(4),
  val INT,
  m_flag CHAR(1),
  q_flag CHAR(1),
  s_flag CHAR(1),
  obs_time CHAR(4)
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = ","
)
STORED AS TEXTFILE
  location '/ndtallant/project/precip/precipitation';

DROP TABLE IF EXISTS ndtallant_precipitation;
CREATE EXTERNAL TABLE ndtallant_precipitation (
  id CHAR(11),
  state CHAR(2),
  p_date DATE,          
  element CHAR(4),    
  val INT
)
STORED AS ORC; 

INSERT OVERWRITE TABLE ndtallant_precipitation
SELECT 
  csv.id,
  sts.state,
  csv.p_date,
  csv.element,
  csv.val
FROM ndtallant_station_to_state AS sts
JOIN ndtallant_precipitation_csv AS csv
  ON sts.station = csv.id
WHERE val != -9999;
