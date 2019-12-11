# Recomputes batch data. Use a cron job or schedule tool (Oozie, airflow)
echo `date` -- "Starting batch compute." >> batch.log
bash precip/run.sh
bash water/run.sh
echo `date` -- "Finished batch compute." >> batch.log

