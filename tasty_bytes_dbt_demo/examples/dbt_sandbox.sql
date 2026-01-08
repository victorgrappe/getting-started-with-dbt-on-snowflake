SHOW TABLES IN DATABASE tasty_bytes_dbt_db;

--SHOW VIEWS IN DATABASE tasty_bytes_dbt_db;

-- SHOW DBT PROJECTS LIKE 'tasty%';


CREATE OR REPLACE TASK tasty_bytes_dbt_db.dev.run_prepped_data_dbt
        WAREHOUSE=tasty_bytes_dbt_wh
        SCHEDULE ='USING CRON 1 * * * * America/Los_Angeles'
      AS
  EXECUTE DBT PROJECT tasty_bytes_dbt_project ARGS='run --select customer_loyalty_metrics --target dev';

--DROP WAREHOUSE IF EXISTS tasty_bytes_dbt_wh;
--DROP DATABASE IF EXISTS tasty_bytes_dbt_db;
--DROP DATABASE IF EXISTS tb_101;