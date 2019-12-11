# Make daily and weekly hbase tables.
hive -f create_hbase.hql

# Insert each state into those tables.
for state in `cat ../01_batch/water/states.txt`; do
  echo "Building HBase Data For ${state^^}"
  sed "s/{{STATE}}/${state}/" hbase_template.hql > use.hql
  hive -f use.hql
  echo `date` -- "Aggregated Daily Data For ${state}" >> serve.log
done
rm use.hql
echo `date` -- "Finished Serve Layer Compute" >> serve.log
