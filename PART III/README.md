# Dataminded Webinar on containers - Part III

This directory contains the code that was used during the hands-on section of the first webinar on containers.
You can rewatch this webinar here:
https://www.dataminded.be/webinars

# Source code
The source code in the `src` folder corresponds to the splitting of the code of Part I in a data pipeline.

# DAG
The `dag_mwaa` folder contains the Airflow dag that was used in the demo to orchestrate the Titanic predictor data pipeline on AWS MWAA.

# Infrastructure
The `infrastructure` directory contains all the Terraform used to provision the infrastructure used in this third part:
- ECR repo
- ECS cluster and task definition
- IAM roles
- S3 bucket
- MWAA environment

If you want to try this, you'll need to change the AWS account and region in the `provider.tf` file.

