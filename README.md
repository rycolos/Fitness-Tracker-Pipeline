# Fitness Tracker Pipeline

## Infrastructure
### Deploy assets with Terraform
Creates Postgres RDS instance and Ubuntu EC2 instance needed for scheduled load and transform
1. Update variables as needed in `variables.tf` and `terraform.tfvars`, removing `TEMPLATE` from the filename
2. `terraform init` if new clone
3. `terraform plan` and verify
4. `terraform apply`

### Configure EC2 for daily transformation
#### Manual EC2 Configuration
1. Update repos - `sudo apt update`
2. Install Git - `sudo apt install git`
3. Install pip - `sudo apt install python3-pip`
4. Install venv - `sudo apt install python3.8-venv`
5. Create `log` directory in home directory for run logs - `mkdir -p ~/log`
5. Clone git repo in home directory
6. Create venv in repo - `cd fitness-tracker-pipeline && python3 -m venv dbt-venv`
7. Activate venv - `source dbt-venv/bin/activate`
8. Install dbt - `python -m pip install dbt-postgres`
9. Update (if needed) and verify dbt profiles.yml - `cd dbt_fit && dbt debug --profiles-dir=profiles`
10. Install load script requirements - `cd load && python -m pip install -r requirements.txt`
11. Ensure git doesn't read changed permissions as a new file - `git config core.fileMode false`
See [here](https://stackoverflow.com/questions/2517339/how-to-restore-the-permissions-of-files-and-directories-within-git-if-they-have).
12. Make run script executable - `cd infra/scripts && sudo chmod u+x run.sh`

#### Automated EC2 Configuration with Ansible
1. Add host to inventory.yaml
2. Update remote_user in `config_transform_ec2.yaml` if needed
3. Run `ansible-playbook -i inventory.yaml config_transform_ec2.yaml --key-file "KEY PATH"` referencing path to AWS .pem key
4. Log in to instance to update dbt project and verify connection: `dbt debug --profiles-dir=profiles`
5. Create cron job for run and update healthchecks.io monitoring UUID

## Data
### Create Raw `raw__weight_daily` table
`psql --host=fitness-db.cpaiz9edoeuq.us-east-1.rds.amazonaws.com --port=5432 --username=postgres1 --password --dbname=postgres -f infra/db_init/create_raw.sql`

### Create, Extract, and Load
#### Initial load of preexistent data
`psql --host=fitness-db.cpaiz9edoeuq.us-east-1.rds.amazonaws.com --port=5432 --username=postgres1 --password --dbname=postgres -f load/load.sql`

#### Create data - Shell Script
Weight is input daily on my local machine with `sh load/data_log.sh ARG` where the argument is my daily weight.

#### Daily extract and load
Triggered manually on local machine following data input step. `python3 load/data_load.py` parses db info and data location from config.yaml, extracts dataframe from raw data file, and inserts into `raw` schema table in RDS Postgres. 

#### Google Sheet
Originally, I was inputting data into a Google Sheet and intended to load that automatically into RDS. Unfortunately, I am deprecating this method as Google makes auth against a private sheet too cumbersome to manage. 

### Transformation and Monitoring
Transformation is run daily at 0600 UTC on an EC2 instance. Monitoring is configured via (healthchecks.io)[https://healthchecks.io]. Simple logging is configured as part of the run script.
`0 6 * * * /home/ubuntu/fitness-tracker-pipeline/infra/scripts/run.sh && curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/UUID`

#### dbt run
`dbt snapshot --profiles-dir=profiles`
`dbt run --profiles-dir=profiles`

`dbt test --profiles-dir=profiles`

### dbt models
* Weight by Day - join on date spine for weight by day
* Weight by Week - join on date spine to avg weight per week
* Weight by Month - join on date spine to avg weight per month

### BI - Hex
* Added Hex IPs to Terraform ingress whitelist
```
3.129.36.245
3.13.16.99
3.18.79.139
```
## Resources
* Followed this guide to get scheduling configured https://kleandata.substack.com/p/cron-dbt-cloud-and-airflow-3-ways