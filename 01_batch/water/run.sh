echo `date` -- "Starting batch water" >> ../batch.log 
bash 01_collect_raw_stations_by_state.sh
bash 02_clean_stations.sh
bash 03_hdfs_to_hive.sh
echo `date` -- "Finished batch water" >> ../batch.log 
