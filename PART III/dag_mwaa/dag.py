import datetime
from airflow import DAG
from airflow.contrib.operators.ecs_operator import ECSOperator

dag = DAG(
    dag_id="titanic_predictor",
    default_args={
        "owner": "airflow",
        "depends_on_past": False,
        "email": ["airflow@example.com"],
        "email_on_failure": False,
        "email_on_retry": False,
    },
    default_view="graph",
    schedule_interval=None,
    start_date=datetime.datetime(2020, 1, 1),
)

def get_task(name, command):
    return ECSOperator(
        task_id=name,
        dag=dag,
        cluster="webinar-containers",
        task_definition=name,
        launch_type="FARGATE",
        overrides={
            "containerOverrides": [
                {
                    "name": name,
                    "command": command,
                },
            ],
        },
        network_configuration={
            'awsvpcConfiguration': {
                'securityGroups': ['sg-06e728c003b403ec2'],
                'subnets': ['subnet-0d6e0f4d529fd6956', 'subnet-09b120b933ab37fd9'],
                'assignPublicIp': "ENABLED"
            },
        },
        awslogs_group="/webinar-containers/titanic-predictor-logs",
        awslogs_stream_prefix=f"ecs/{name}",
    )

ingest_training = get_task("ingest_training", [
      "--job", "ingest",
      "--asset", "training",
      "--date", "{{ next_ds }}",    
])
ingest_test = get_task("ingest_test", [
      "--job", "ingest",
      "--asset", "test",
      "--date", "{{ next_ds }}",    
])
clean_training = get_task("clean_training", [
      "--job", "clean",
      "--asset", "training",
      "--date", "{{ next_ds }}",    
])
clean_test = get_task("clean_test", [
      "--job", "clean",
      "--asset", "test",
      "--date", "{{ next_ds }}",    
])
train_model = get_task("train_model", [
      "--job", "train",
      "--date", "{{ next_ds }}",    
])
predict = get_task("predict", [
      "--job", "predict",
      "--date", "{{ next_ds }}",    
])

ingest_training >> clean_training >> train_model >> predict
ingest_test >> clean_test >> predict