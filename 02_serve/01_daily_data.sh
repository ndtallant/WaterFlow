for state in `cat ../01_batch/water/states.txt`; do
  echo "Building Daily Data For ${state^^}"
  sed "s/{{STATE}}/${state}/" daily_data_template.hql |
  sed "s/{{BIG_STATE}}/${state^^}/" > use.hql
  hive -f use.hql
  echo `date` -- "Created Daily Data For ${state}" >> serve.log
done
rm use.hql
