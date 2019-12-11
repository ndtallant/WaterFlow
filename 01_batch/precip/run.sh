echo `date` -- "Starting batch precipitation" >> ../batch.log
bash get_precip.sh
hive -f hdfs_to_hive.hql
echo `date` -- "Finished batch precipitation" >> ../batch.log
