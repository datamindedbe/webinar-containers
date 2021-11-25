import joblib
import os

def model_fn(model_dir):
    clf = joblib.load(os.path.join(model_dir, "model.joblib"))
    print("here")
    print(clf)
    return clf
