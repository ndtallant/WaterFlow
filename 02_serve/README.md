## Daily Data Creation

This directory makes hive tables for every state following the naming convention `ndtallant_daily_<state>`. Those tables are then written to a single hbase table `ndtallant_serve_daily`, where the key is a concatenation of the state and date `SS-YYYY-MM-DD`.

#### Files

* `01_daily_data.sh`
  * `daily_data_template.hql`
* `02_daily_to_hbase.sh`
  * `create_hbase.hql`
  * `hbase_template.hql`
