# This file refreshes all precipitation raw data.

# Remove old data.
hdfs dfs -rm "/ndtallant/project/precip/precipitation/precipitation.csv"

# Collect raw data.
this_year=`date +%Y`
for ((year=2016; year<=$this_year; year++))
do
  wget "ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/by_year/${year}.csv.gz"
  gunzip "${year}.csv.gz"
  awk -F "," '{OFS=","; print $1, substr($2,0,4)"-"substr($2,5,2)"-"substr($2,7,2), $3, $4}' "${year}.csv" > "data/${year}.csv"
  echo `date` -- "Adding precipitation ${year} to HDFS" >> ../batch.log
  hdfs dfs -appendToFile "data/${year}.csv" "/ndtallant/project/precip/precipitation/precipitation.csv"
  rm "${year}.csv" 
done
