for state in `cat ../water/states.txt`; do
  echo "Building Daily Data For ${state^^}"
  sed "s/{{STATE}}/${state}/" daily_data_template.hql |
  sed "s/{{BIG_STATE}}/${state^^}/" > use.hql
  hive -f use.hql
done
rm use.hql
