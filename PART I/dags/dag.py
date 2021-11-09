from airflow import DAG
from airflow.models import Variable
from datafy.operators import DatafyContainerOperator, DatafyContainerOperatorV2
from datetime import datetime

default_args = {
    "owner": "Data Minded",
    "depends_on_past": False,
    "start_date": datetime.now(),
    "retries": 0,
}

dag = DAG(
    "titanic-survival-predictor",
    default_args=default_args,
    schedule_interval="@daily",
    max_active_runs=1,
)

DatafyContainerOperatorV2(
    dag=dag,
    task_id="titanic-survival-predictor",
    arguments=[
      "--bucket", "webinar-containers-data",
      "--training", "part1/titanic/train.csv",
      "--new-passengers", "part1/titanic/test.csv",
      "--predictions", "part1/titanic/output.csv"
    ],
    aws_role="titanic-survival-predictor-datafy-role",
)