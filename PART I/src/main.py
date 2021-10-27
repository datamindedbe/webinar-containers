import argparse
import logging
import os
import sys

import pandas as pd
import awswrangler as wr
import boto3

from src.predictor import Predictor


class Config:
    def __init__(self, bucket: str, training_path: str, new_passengers_path: str, predictions_path: str):
        self.bucket = bucket
        self.training_path = training_path
        self.new_passengers_path = new_passengers_path
        self.predictions_path = predictions_path


def setup_aws_session():
    aws_access_key_id = os.getenv('AWS_ACCESS_KEY_ID')
    aws_secret_access_key = os.getenv('AWS_SECRET_ACCESS_KEY')
    aws_region = os.getenv('AWS_REGION')
    boto3.setup_default_session(
        aws_access_key_id=aws_access_key_id,
        aws_secret_access_key=aws_secret_access_key,
        region_name=aws_region
    )


def load_data(bucket: str, path: str) -> pd.DataFrame:
    s3path = f's3://{bucket}/{path}'
    logging.info(f"Loading data from {s3path}")
    return wr.s3.read_csv(path=s3path)


def write_data(df: pd.DataFrame, bucket: str, path: str):
    s3path = f's3://{bucket}/{path}'
    logging.info(f"Writing data to {s3path}")
    wr.s3.to_csv(df, path=s3path)


def main(config: Config):
    setup_aws_session()

    training_input_df = load_data(config.bucket, config.training_path)
    new_passengers_df = load_data(config.bucket, config.new_passengers_path)

    predictor = Predictor(training_input_df, new_passengers_df)
    predictor.train()
    survivors_prediction_df = predictor.get_prediction()
    logging.info(f"Here is a sample of the predictions: \n{survivors_prediction_df.head(20)}")

    write_data(survivors_prediction_df, config.bucket, config.predictions_path)
    logging.info(f"All done!")


def parse_args() -> Config:
    parser = argparse.ArgumentParser(description="Titanic survival predictor")
    parser.add_argument(
        "-b", "--bucket", dest="bucket",
        help="The AWS S3 bucket name where the data can be found", required=True
    )
    parser.add_argument(
        "-t", "--training", dest="training_path",
        help="The path to the training data set csv file in the S3 bucket", required=True
    )
    parser.add_argument(
        "-n", "--new-passengers", dest="new_passengers_path",
        help="The path to the new passengers data set csv file in the S3 bucket", required=True
    )
    parser.add_argument(
        "-p", "--predictions", dest="predictions_path",
        help="The path where to output the new passengers survival predictions csv file in the S3 bucket", required=True
    )
    args = parser.parse_args()
    return Config(args.bucket, args.training_path, args.new_passengers_path, args.predictions_path)


if __name__ == '__main__':
    logging.basicConfig(stream=sys.stdout, level=logging.INFO)
    main(parse_args())
