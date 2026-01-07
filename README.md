# Getting Started with dbt on Snowflake

## Overview

This repository contains an example dbt project to get you started with dbt on Snowflake.

## Tutorial

[Set up your environment](<https://docs.snowflake.com/fr/user-guide/tutorials/dbt-projects-on-snowflake-getting-started-tutorial#create-a-workspace-connected-to-your-git-repository>)

```bash
snow sql
```

```sql
--CREATE WAREHOUSE tasty_bytes_dbt_wh WAREHOUSE_SIZE = XLARGE;
DROP WAREHOUSE IF EXISTS tasty_bytes_dbt_wh;

CREATE OR REPLACE WAREHOUSE tasty_bytes_dbt_wh WITH
  WAREHOUSE_SIZE='X-SMALL'
  AUTO_SUSPEND = 180
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED=TRUE;

SELECT CURRENT_WAREHOUSE();

CREATE DATABASE tasty_bytes_dbt_db;
CREATE SCHEMA tasty_bytes_dbt_db.integrations;
CREATE SCHEMA tasty_bytes_dbt_db.dev;
CREATE SCHEMA tasty_bytes_dbt_db.prod;

-- Create an API integration in Snowflake for connecting to GitHub
USE tasty_bytes_dbt_db.integrations;
CREATE OR REPLACE SECRET tasty_bytes_dbt_db.integrations.tb_dbt_git_secret
  TYPE = password
  USERNAME = 'victorgrappe'
  PASSWORD = 'github_pat_11AIPKOFQ0vZ7ELnixw7Ki_XXXX';

CREATE OR REPLACE API INTEGRATION tb_dbt_git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/victorgrappe')
  -- Comment out the following line if your forked repository is public
  ALLOWED_AUTHENTICATION_SECRETS = (tasty_bytes_dbt_db.integrations.tb_dbt_git_secret)
  ENABLED = TRUE;

-- Create NETWORK RULE for external access integration
CREATE OR REPLACE NETWORK RULE dbt_network_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  -- Minimal URL allowlist that is required for dbt deps
  VALUE_LIST = (
    'hub.getdbt.com',
    'codeload.github.com'
    );

-- Create EXTERNAL ACCESS INTEGRATION for dbt access to external dbt package locations
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION dbt_ext_access
  ALLOWED_NETWORK_RULES = (dbt_network_rule)
  ENABLED = TRUE;
```
