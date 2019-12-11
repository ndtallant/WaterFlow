# This collects a sample of water stations that measure discharge,
# and organizes them by state for cleaning and merging.

for f in `ls station_meta | grep tsv`;
do
  state=`echo $f | cut -d . -f 1`
  mkdir "historical_by_state/${state}"

  echo $f
  awk -F '\t' '{print $2}' "station_meta/${f}" |
    head -100 |
    sed '/site_no/d' > "historical_by_state/${state}/station_list.txt"

  for station in `cat historical_by_state/${state}/station_list.txt`;
  do
    echo `date` -- "Collecting ${station}" >> ../batch.log
    curl "https://waterservices.usgs.gov/nwis/dv/?format=rdb&sites=${station}&startDT=2016-01-01&parameterCd=00060&siteStatus=all" -o "historical_by_state/${state}/${station}.txt"
  done
  echo `date` -- "Finished collecting raw data for ${state}"
done

