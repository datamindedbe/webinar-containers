import argparse
import sys
import logging
from config import Config

# from jobs import entrypoint
# # noinspection PyUnresolvedReferences
from jobs import ingest
# noinspection PyUnresolvedReferences
from jobs import clean
# # noinspection PyUnresolvedReferences
from jobs import train
# # noinspection PyUnresolvedReferences
from jobs import predict


def main(config: Config):
    # setup_aws_session()
    logging.info(f"Executing job {config.job}")
    # job = entrypoint.all[config.job]
    # job(config)
    entrypoint = {}
    entrypoint["ingest"] = ingest
    entrypoint["clean"] = clean
    entrypoint["train"] = train
    entrypoint["predict"] = predict

    entrypoint[config.job].run(config)


def parse_args() -> Config:
    parser = argparse.ArgumentParser(description="titanic-survival-predictor")
    parser.add_argument(
        "-d", "--date", dest="date", help="date in format YYYY-mm-dd", required=True
    )
    parser.add_argument(
        "-a", "--asset", dest="asset", help="Asset you want to ingest or load", required=False
    )
    parser.add_argument(
        "-j",
        "--job",
        dest="job",
        help="job that must be executed",
        required=True,
    )
    args = parser.parse_args()
    return Config(args.asset, args.date, args.job)


if __name__ == '__main__':
    logging.basicConfig(stream=sys.stdout, level=logging.INFO)
    main(parse_args())
