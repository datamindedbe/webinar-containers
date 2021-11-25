import boto3

runtime = boto3.client('runtime.sagemaker')

with open('test_features.csv', 'r') as file:
    data = file.read()

print(data)

response = runtime.invoke_endpoint(EndpointName="titanic-predictor-2021-11-23-15-01-47-151",
                                   ContentType='text/csv',
                                   Body=data)
