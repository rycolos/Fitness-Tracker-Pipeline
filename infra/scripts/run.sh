#!/bin/bash

cd /home/ubuntu/fitness-tracker-pipeline
git pull
source dbt-venv/bin/activate
cd dbt_fin
dbt snapshot
dbt run