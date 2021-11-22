import logging
import tempfile
import boto3
import joblib
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier

import titanicpredictor.datalake as datalake
from titanicpredictor.config import Config
from titanicpredictor.jobs import entrypoint


@entrypoint("train")
def run(config: Config):
    logging.info("Training the classifier")
    s3_resource = boto3.resource('s3')
    key = "part3/model/classifier.pkl"
    pd.set_option("display.max_rows", None, "display.max_columns", None)

    training_features = datalake.load_parquet("features", config.date, "training").values
    training_target = get_target_from_df(datalake.load_parquet("raw", config.date, "training"))
    clf = RandomForestClassifier(n_estimators=100)
    clf = clf.fit(training_features, training_target)
    with tempfile.TemporaryFile() as temp_file:
        joblib.dump(clf, temp_file)
        temp_file.seek(0)
        s3_resource.meta.client.put_object(Body=temp_file.read(), Bucket=datalake.get_bucket(), Key=key)
    logging.info("Training done.")


def get_target_from_df(df: pd.DataFrame) -> np.array:
    return df['Survived'].astype('int').values
