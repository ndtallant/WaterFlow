# This script creates hive tables for all 50 states.
for state in `cat states.txt`; do
  sed "s/{{STATE}}/${state}/" hdfs_to_hive_template.hql > use.hql
  hive -f use.hql
  echo `date` -- "Added ${state} to hdfs" >> ../batch.log
done
rm use.hql
echo `date` -- "Finished Batch Water" >> ../batch.log

