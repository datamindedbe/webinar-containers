import logging

import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier


class Predictor:

    def __init__(self, training_df: pd.DataFrame, test_df: pd.DataFrame):
        self.training_df = training_df
        self.test_df = test_df
        self.clf = None

    def train(self):
        logging.info("Extracting features and target from training set")
        training_features = self._get_features_from_df(self.training_df, drop_survived=True)
        training_target = self._get_target_from_df(self.training_df)
        logging.info("Training the classifier")
        self.clf = RandomForestClassifier(n_estimators=100)
        self.clf = self.clf.fit(training_features, training_target)

    def get_prediction(self) -> pd.DataFrame:
        logging.info("Extracting features from new data set")
        test_features = self._get_features_from_df(self.test_df)
        logging.info("Predicting survival for new data set")
        test_predictions = self.clf.predict(test_features)
        predictions_df = self.test_df.copy()
        predictions_df['Survived'] = test_predictions
        predictions_df = predictions_df[['PassengerId', 'Survived']]
        return predictions_df

    @staticmethod
    def _add_gender_feature(df: pd.DataFrame):
        sexes = sorted(df['Sex'].unique())
        genders_mapping = dict(zip(sexes, range(0, len(sexes) + 1)))
        df['Sex_Val'] = df['Sex'].map(genders_mapping).astype(int)

    @staticmethod
    def _add_age_feature(df: pd.DataFrame):
        df['AgeFill'] = df['Age']
        df['AgeFill'] = df['AgeFill']. \
            groupby([df['Sex_Val'], df['Class']]). \
            apply(lambda x: x.fillna(x.median()))

    @staticmethod
    def _add_family_size_feature(df: pd.DataFrame):
        df['FamilySize'] = df['Siblings'] + df['ParentsChildren']

    @staticmethod
    def _get_features_from_df(df: pd.DataFrame, drop_survived: bool = False) -> np.array:
        features_df = df.copy()
        Predictor._add_gender_feature(features_df)
        Predictor._add_age_feature(features_df)
        Predictor._add_family_size_feature(features_df)
        features_df = features_df.drop(
            ['Name', 'Sex', 'Ticket', 'Cabin', 'Embarked', 'Age', 'Siblings', 'ParentsChildren', 'Fare'], axis=1
        )
        if drop_survived:
            features_df = features_df.drop(['Survived'], axis=1)
        return features_df.values

    @staticmethod
    def _get_target_from_df(df: pd.DataFrame) -> np.array:
        return df['Survived'].values
