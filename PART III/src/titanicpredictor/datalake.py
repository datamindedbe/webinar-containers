import logging
import awswrangler as wr
import pandas as pd


def get_bucket() -> str:
    return "webinar-containers-data"


def key_prefix() ->str:
    return "part3"


def load_csv(path: str) -> pd.DataFrame:
    s3path = f's3://{get_bucket()}/{key_prefix()}/{path}'
    logging.info(f"Loading csv data from {s3path}")
    return wr.s3.read_csv(path=s3path)


def write_parquet(df: pd.DataFrame, path: str, date: str, name: str):
    s3path = f's3://{get_bucket()}/{key_prefix()}/{path}/date={date}/{name}.parquet'
    logging.info(f"Writing parquet data to {s3path}")
    wr.s3.to_parquet(df, path=s3path)


def load_parquet(path: str, date: str, name: str):
    s3path = f's3://{get_bucket()}/{key_prefix()}/{path}/date={date}/{name}.parquet'
    logging.info(f"Loading parquet data from {s3path}")
    return wr.s3.read_parquet(path=s3path)

