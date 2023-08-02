#!/bin/bash

cd /home/ubuntu/fitness-tracker-pipeline
git pull
source dbt-venv/bin/activate
cd dbt_fit
dbt snapshot
dbt run