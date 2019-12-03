for year in {2016..2019};
do
  wget "ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/by_year/${year}.csv.gz"
  gunzip "${year}.csv.gz"
  hdfs dfs -put "${year}.csv" /ndtallant/project/precip/
  mv "${year}.csv" data/
done
