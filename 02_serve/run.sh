echo "Starting Serve Compute."
bash 01_daily_data.sh
bash 02_serve_to_hbase.sh
echo "Finished Serve Compute."
