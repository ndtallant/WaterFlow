# This script creates hive tables for all 50 states.
state="wv"
sed "s/{{STATE}}/${state}/" hdfs_to_hive_template.hql > use.hql
hive -f use.hql

