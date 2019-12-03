hive -f create_hbase.hql
for state in `cat water/states.txt`; do
  echo "Building HBase Data For ${state^^}"
  sed "s/{{STATE}}/${state}/" hbase_template.hql > use.hql
  hive -f use.hql
done
rm use.hql
