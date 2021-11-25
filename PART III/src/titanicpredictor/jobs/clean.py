import logging
import pandas as pd

import titanicpredictor.datalake as datalake
from titanicpredictor.config import Config
from titanicpredictor.jobs import entrypoint



@entrypoint("clean")
def run(config: Config):
    logging.info(f"Extracting features for dataset {config.asset} for date {config.date}...")
    df = datalake.load_parquet("raw", config.date, config.asset)

    features_df = df.copy()
    add_gender_feature(features_df)
    add_age_feature(features_df)
    add_family_size_feature(features_df)
    features_df = features_df.drop(
        ['Name', 'Sex', 'Ticket', 'Cabin', 'Embarked', 'Age', 'Siblings', 'ParentsChildren', 'Fare'], axis=1
    )
    if config.asset == "training":
        features_df = features_df.drop(['Survived'], axis=1)

    datalake.write_parquet(features_df, "features", config.date, config.asset)
    logging.info(f"Done extracting features.")


def add_gender_feature(df: pd.DataFrame):
    sexes = sorted(df['Sex'].unique())
    genders_mapping = dict(zip(sexes, range(0, len(sexes) + 1)))
    df['Sex_Val'] = df['Sex'].map(genders_mapping).astype(int)


def add_age_feature(df: pd.DataFrame):
    df['AgeFill'] = df['Age']
    df['AgeFill'] = df['AgeFill']. \
        groupby([df['Sex_Val'], df['Class']]). \
        apply(lambda x: x.fillna(x.median()))


def add_family_size_feature(df: pd.DataFrame):
    df['FamilySize'] = df['Siblings'] + df['ParentsChildren']
