# This file cleans all station data files contained in historical_by_state/
# and puts the data in TSVs on HDFS.
# It utilizes standard unix tools to run quickly.
# Note hdfs:/ndtallant/project/water/ needs to exist!

# Remove sites with no data.
grep -r -i "No sites found" historical_by_state/ > remove.txt 
sed -i 's/:#.*$//' remove.txt
for f in `cat remove.txt`; do rm $f; done
rm remove.txt

# For each station, remove the comment header and 2nd row of format information.
# Take that cleaned data and put it into hdfs.
for state in `ls historical_by_state`; do
  # Leave out station_list.txt
  for f in `ls "historical_by_state/${state}/" | grep ^[0-9]`; do
    station=`echo "${f}" | cut -d . -f 1`

    # Make a temp file of just data.
    echo "Cleaning station # ${station}"
      sed '/^#/d' "historical_by_state/${state}/${f}" |
      sed '2d' |
      sed 's/[0-9]\+_00060_[0-9]\+/discharge/' > temp.tsv 

    # Identify the column number for discharge, as schemas may differ. 
    dcol=`head -1 temp.tsv |
            tr "\t" "\n" |
            grep -nx "discharge" |
            cut -d ":" -f 1`

    # Create the output file. Append to hdfs.
    awk -F "\t" -v dcol=$dcol -v OFS="\t" '{print $1, $2, $3, $dcol}' temp.tsv |
      sed '1d' > out.tsv
    
    hdfs dfs -appendToFile out.tsv "/ndtallant/project/water/${state}/${state}.tsv"
  done
done
rm out.tsv
rm temp.tsv
