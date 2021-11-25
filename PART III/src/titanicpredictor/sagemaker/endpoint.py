from sagemaker.sklearn.model import SKLearnModel

model = SKLearnModel(
    name='titanic-predictor',
    model_data='s3://webinar-containers-data/part3/sagemaker/model.tar.gz',
    role='webinar-containers-sagemaker',
    entry_point='inference_script.py',
    framework_version='0.23-1')

model.deploy(
    instance_type='ml.t2.medium',
    initial_instance_count=1)
