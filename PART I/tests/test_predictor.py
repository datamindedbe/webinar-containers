import unittest
import pandas as pd

from src.predictor import Predictor


class PredictorTest(unittest.TestCase):
    def test_add_gender_feature(self):
        df = pd.DataFrame({
            'Sex': ['male', 'male', 'female', 'male', 'female']
        })
        Predictor._add_gender_feature(df)
        self.assertEqual(len(df[df['Sex_Val'] == 1]), 3)
        self.assertEqual(len(df[df['Sex_Val'] == 0]), 2)

    def test_add_age_feature(self):
        df = pd.DataFrame({
            'Sex': [
                'male', 'male', 'female', 'male', 'female', 'female',
                'female', 'male', 'female', 'female', 'male', 'male',
            ],
            'Age': [
                12, 38, 27, None, 15, None,
                None, 17, 27, 2, None, 17,
            ],
            'Class': [
                1, 1, 1, 1, 1, 1,
                2, 2, 2, 2, 2, 2
            ]
        })
        Predictor._add_gender_feature(df)
        Predictor._add_age_feature(df)
        self.assertEqual(df['AgeFill'][3], 25)
        self.assertEqual(df['AgeFill'][5], 21)
        self.assertEqual(df['AgeFill'][6], 14.5)
        self.assertEqual(df['AgeFill'][10], 17)
