#!/bin/bash

echo $(date) >> /home/ubuntu/log/run-log.log
echo $(date) >> /home/ubuntu/log/pull-log.log

cd /home/ubuntu/fitness-tracker-pipeline
git pull >> /home/ubuntu/log/pull-log.log
source dbt-venv/bin/activate
cd dbt_fit
dbt snapshot --profiles-dir=profiles >> /home/ubuntu/log/run-log.log
dbt run --profiles-dir=profiles >> /home/ubuntu/log/run-log.log

echo >> /home/ubuntu/log/run-log.log
echo >> /home/ubuntu/log/pull-log.log