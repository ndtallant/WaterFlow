for year in {2016..2019};
do
  wget "ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/by_year/${year}.csv.gz"
  gunzip "${year}.csv.gz"
  awk -F "," '{OFS=","; print $1, substr($2,0,4)"-"substr($2,5,2)"-"substr($2,7,2), $3, $4}' "${year}.csv" > "data/${year}.csv"
  hdfs dfs -put "data/${year}.csv" "/ndtallant/project/precip/p${year}/"
  rm "${year}.csv" 
done
