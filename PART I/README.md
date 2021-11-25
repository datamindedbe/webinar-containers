# Dataminded Webinar on containers - Part I

This directory contains the code that was used during the hands-on section of the first webinar on containers.
You can rewatch this webinar here:
https://www.dataminded.be/webinars

# How to build the Titanic survival predictor Docker image
To build the image, you need Docker installed on your machine.
You can then run the following command in this directory:
```
docker build . -t titanic-survival-predictor:v1
```

# How to run the Titanic survival predictor as a local Docker container

The Titanic survival predictor takes as input:
- a training dataset on S3 (dentoted `_path_to_training_set_` below)
- a test dataset on S3 (denoted `_path_to_test_set_v` below)

It will output the prediction of survival for the test set in a file on S3 (denoted `_desired_output_path_on_s3_`).

In order to run the container, you will need an S3 bucket (denoted `your_s3_bucket` below) with the corresponding input files.
The input files can be found in the `data` folder in this repo.
You will also need AWS credentials that you can pass as environment variables to the container so that it can access the S3 bucket (denoted `_your_access_key_id_`, `_your_secret_access_key_` and `_your_aws_region_` below).

Once you have set up an S3 bucket with the input files, and you have AWS credentials, you can run the container as follows:
```
 docker run \                                                                                  
  -e AWS_ACCESS_KEY_ID=_your_access_key_id_ \
  -e AWS_SECRET_ACCESS_KEY=_your_secret_access_key_ \
  -e AWS_REGION=_your_aws_region_ \
  titanic-survival-predictor:v1 \
  --bucket your_s3_bucket \
  --training _path_to_training_set_ \
  --new-passengers _path_to_test_set_v \
  --prediction _desired_output_path_on_s3_
```