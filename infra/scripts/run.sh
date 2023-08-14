#!/bin/bash

cd /home/ubuntu/fitness-tracker-pipeline

git pull >> /home/ubuntu/log/$(date +"%Y-%m-%d")_pull.log

source dbt-venv/bin/activate

cd dbt_fit
dbt snapshot --profiles-dir=profiles >> /home/ubuntu/log/$(date +"%Y-%m-%d")_run.log
dbt run --profiles-dir=profiles >> /home/ubuntu/log/$(date +"%Y-%m-%d")_run.log

#delete logs older than 14d
find /home/ubuntu/log -name "*.log" -type f -mtime +14 -delete