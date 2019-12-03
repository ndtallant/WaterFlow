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


DROP TABLE IF EXISTS p2019;
CREATE EXTERNAL TABLE p2019 (
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
  location '/ndtallant/project/precip/p2019';


DROP TABLE IF EXISTS p2018;
CREATE EXTERNAL TABLE p2018 (
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
  location '/ndtallant/project/precip/p2018';

DROP TABLE IF EXISTS p2017;
CREATE EXTERNAL TABLE p2017 (
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
  location '/ndtallant/project/precip/p2017';

DROP TABLE IF EXISTS p2016;
CREATE EXTERNAL TABLE p2016 (
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
  location '/ndtallant/project/precip/p2016';


DROP TABLE IF EXISTS ndtallant_p2016;
CREATE EXTERNAL TABLE ndtallant_p2016 (
  id CHAR(11),
  state CHAR(2),
  p_date DATE,          
  element CHAR(4),    
  val INT
)
STORED AS ORC; 

INSERT OVERWRITE TABLE ndtallant_p2016
SELECT 
  p2016.id,
  sts.state,
  p2016.p_date,
  p2016.element,
  p2016.val
FROM ndtallant_station_to_state AS sts
JOIN p2016
  ON sts.station = p2016.id;

DROP TABLE IF EXISTS ndtallant_p2017;
CREATE EXTERNAL TABLE ndtallant_p2017 (
  id CHAR(11),
  state CHAR(2),
  p_date DATE,          
  element CHAR(4),    
  val INT
)
STORED AS ORC; 

INSERT OVERWRITE TABLE ndtallant_p2017
SELECT 
  p2017.id,
  sts.state,
  p2017.p_date,
  p2017.element,
  p2017.val
FROM ndtallant_station_to_state AS sts
JOIN p2017
  ON sts.station = p2017.id;

DROP TABLE IF EXISTS ndtallant_p2018;
CREATE EXTERNAL TABLE ndtallant_p2018 (
  id CHAR(11),
  state CHAR(2),
  p_date DATE,          
  element CHAR(4),    
  val INT
)
STORED AS ORC; 

INSERT OVERWRITE TABLE ndtallant_p2018
SELECT 
  p2018.id,
  sts.state,
  p2018.p_date,
  p2018.element,
  p2018.val
FROM ndtallant_station_to_state AS sts
JOIN p2018
  ON sts.station = p2018.id;

DROP TABLE IF EXISTS ndtallant_p2019;
CREATE EXTERNAL TABLE ndtallant_p2019 (
  id CHAR(11),
  state CHAR(2),
  p_date DATE,          
  element CHAR(4),    
  val INT
)
STORED AS ORC; 

INSERT OVERWRITE TABLE ndtallant_p2019
SELECT 
  p2019.id,
  sts.state,
  p2019.p_date,
  p2019.element,
  p2019.val
FROM ndtallant_station_to_state AS sts
JOIN p2019
  ON sts.station = p2019.id;
