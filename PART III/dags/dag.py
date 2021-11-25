from airflow import DAG
from datafy.operators import DatafyContainerOperatorV2
from datetime import datetime

default_args = {
    "owner": "Data Minded",
    "depends_on_past": False,
    "start_date": datetime.now(),
    "retries": 0,
}

dag = DAG(
    "titanic-predictor",
    default_args=default_args,
    schedule_interval="@daily",
    max_active_runs=1,
)

role="titanic-predictor-datafy-role"

ingest_training_task = DatafyContainerOperatorV2(
    dag=dag,
    task_id="ingest_training_data",
    instance_type='mx_nano',
    arguments=[
      "--job", "ingest",
      "--asset", "training",
      "--date", "{{ next_ds }}",
    ],
    aws_role=role,
)

ingest_test_task = DatafyContainerOperatorV2(
    dag=dag,
    task_id="ingest_test_data",
    instance_type='mx_nano',
    arguments=[
        "--job", "ingest",
        "--asset", "test",
        "--date", "{{ next_ds }}",
    ],
    aws_role=role,
)

clean_training_task = DatafyContainerOperatorV2(
    dag=dag,
    task_id="clean_training_data",
    instance_type='mx_nano',
    arguments=[
        "--job", "clean",
        "--asset", "training",
        "--date", "{{ next_ds }}",
    ],
    aws_role=role,
)

clean_test_task = DatafyContainerOperatorV2(
    dag=dag,
    task_id="clean_test_data",
    instance_type='mx_nano',
    arguments=[
        "--job", "clean",
        "--asset", "test",
        "--date", "{{ next_ds }}",
    ],
    aws_role=role,
)

train_task = DatafyContainerOperatorV2(
    dag=dag,
    task_id="train_predictor",
    instance_type='mx_nano',
    arguments=[
        "--job", "train",
        "--date", "{{ next_ds }}",
    ],
    aws_role=role,
)

predict_task = DatafyContainerOperatorV2(
    dag=dag,
    task_id="predict",
    instance_type='mx_nano',
    arguments=[
        "--job", "predict",
        "--date", "{{ next_ds }}",
    ],
    aws_role=role,
)


ingest_training_task >> clean_training_task >> train_task >> predict_task
ingest_test_task >> clean_test_task >> predict_task