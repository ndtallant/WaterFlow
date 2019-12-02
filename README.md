# Water Flow 
An at scale exploration of precipitation and water station discharge.

## Water
0. Get some basic information.
  - `get_station_meta.py`: Get meta info for all stations
  - `station_meta/`: Said meta info
  - `states.txt`: All of the states in the US
1. `collect_raw_stations_by_state.sh`: Gets 100 stations for each state as a text file.
                                     Raw data lives in historical_by_state/
2. `clean_stations.sh`: Removes data comments, identifies the discharge column, and appends
                      to files in HDFS (/ndtallant/project/water/{state}.tsv)

## Precipitation

0. Information
- `format_precip.txt`
- `ghcnd-states.txt`
- `ghcnd-stations.txt`
- `readme.txt`

1. `get_precip.sh`: All data from NOAA by year.
2. Put into hdfs, note the state of each station?
3. make external hive tables
