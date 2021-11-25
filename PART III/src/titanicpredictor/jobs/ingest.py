import logging

import titanicpredictor.datalake as datalake
from titanicpredictor.config import Config
from titanicpredictor.jobs import entrypoint


@entrypoint("ingest")
def run(config: Config):
    logging.info(f"Ingesting {config.asset} dataset for date {config.date}...")
    df = datalake.load_csv(f"{config.asset}.csv")
    datalake.write_parquet(df, "raw", config.date, config.asset)
    logging.info(f"Done ingesting.")

