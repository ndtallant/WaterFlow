# Water Flow 
This application is a dashboard to examine USGS water station discharge and NOAA precipitation for the entire United States.
It follows the popular [Lambda Architecture](https://databricks.com/glossary/lambda-architecture) to handle the sheer volume
of data and to scale continuously without mitigating performance.

### Data Sources
* Daily Pecipitation Summaries From NOAA's [National Centers for Environmental Information](https://www.ncdc.noaa.gov/)
* USGS [Water Services API](https://waterservices.usgs.gov/)

### Batch Layer
As the source of ground truth, this portion of the application is responsible for collecting and storing minimally processed data.
This is accomplished the same way for both precipitation and water data:

1. Collect raw text data from sources.
2. Conduct light processing to ensure valid data with a consistent schema.
3. Store in HDFS.
4. Store in Hive as [Optimized Row Columnar](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+ORC) files.

#### Precipitation
* `readme.txt`: Data documentation provided by NOAA.
* `run.sh`: This file is all that needs to be run. It extracts, transforms, and loads all precipitation data.
* `get_precip.sh`: Called by `run.sh`, this file collects raw data from NOAA and stores is in HDFS.
* `hdfs_to_hive.hql`: Called by `run.sh`, this file stores data as the ORC Hive table `ndtallant_precipitation`.

#### Water
Baseline information needed to be collected before the actual data. This is handled by:
* `get_station_meta.py`: Collects all metadata for water stations by state and stores it in `station_meta/`.
* `states.txt`: All of the states in the US.

Actual data collection occurs by:
* `01_collect_raw_stations_by_state.sh`: This file collects a random sample of stations for each state as a text file to preserve shared resources. It can be modified to collect all available water data across the United States.
* `02_clean_stations.sh`: This file removes data comments, identifies the discharge column, and appends to files in HDFS (/ndtallant/project/water/{state}.tsv)
* `03_hdfs_to_hive.sh`: This file stores data as ORC Hive tables following the naming convention `ndtallant_{state}`. It utilizes `hdfs_to_hive_template.hql`.

### Serve Layer
This portion of the application computes and stores relevant data to be quickly accessed by the web application, specifically daily, weekly, and monthly aggregations of both precipitation and water data by state.
These are stored in the [HBase](https://hbase.apache.org/) tables `ndtallant_serve_daily`, `ndtallant_serve_weekly`, and `ndtallant_serve_monthly`, respectively.
Each table's key follows the naming convention of `STATE-DATE`, where state is the two character state abbreviation and date is:
* `YYYY-MM-DD` for daily data.
* `NN-YYYY`, for weekly data, where `NN` is the number of the week of that year.
* `ABR-YYYY` for monthly data, where `ABR` is the abbreviation of that month, such as Jan.

Files used to accomplish this task are:
* `01_daily_data.sh`: Aggregates state level data by day `YYYY-MM-DD` using `daily_data_template.hql`.
* `02_serve_to_hbase.sh`: Computes the weekly and monthly aggregations and stores all serve layer data in Hbase using `create_hbase.hql` and `hbase_template.hql`.
* `UPDATE ME`DeleteTable.java

### Speed Layer
This portion of the application collects the most recent water data, aggregates it, and stores it in the HBase table `ndtallant_speed` using `get_recent_water.py`. 
The resulting table has a row for each state, where the key is the state and the columns are `discharge` and `n_discharge`. It is set to run hourly.
