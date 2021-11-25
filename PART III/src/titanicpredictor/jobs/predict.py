import titanicpredictor.datalake as datalake
from titanicpredictor.config import Config
from titanicpredictor.jobs import entrypoint

import logging
import boto3
import tempfile
import joblib


@entrypoint("predict")
def run(config: Config):
    with tempfile.TemporaryFile() as temp_file:
        logging.info("Predicting titanic survival for test dataset.")
        test_features = datalake.load_parquet("features", config.date, "test")

        s3_resource = boto3.resource('s3')
        key = "part3/model/classifier.pkl"
        s3_resource.meta.client.download_fileobj(Fileobj=temp_file, Bucket=datalake.get_bucket(), Key=key)
        temp_file.seek(0)
        classifier = joblib.load(temp_file)

        test_predictions = classifier.predict(test_features)
        predictions_df = test_features.copy()
        predictions_df['Survived'] = test_predictions
        predictions_df = predictions_df[['PassengerId', 'Survived']]

        datalake.write_parquet(predictions_df, "predictions", config.date, "predictions")
        logging.info("Prediction done.")
