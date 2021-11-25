# Dataminded Webinar on containers - Part II

This directory contains the code that was used during the hands-on section of the first webinar on containers.
You can rewatch this webinar here:
https://www.dataminded.be/webinars

# Infrastructure
The `infrastructure` directory contains all the Terraform used to provision the infrastructure used in this second part:
- ECR repo
- ECS cluster and task definition
- IAM roles
- S3 bucket

If you want to try this, you'll need to change the AWS account and region in the `provider.tf` file.
