resource "aws_ecs_cluster" "webinar_containers" {
  name               = "webinar-containers"
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "titanic_survival_predictor" {
  family                   = "titanic-survival-predictor"
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions    = jsonencode([{
    name        = "titanic-survival-predictor"
    networkMode = "awsvpc"
    cpu         = 256
    memory      = 512
    image      = "130966031144.dkr.ecr.eu-west-1.amazonaws.com/webinar-containers/titanic-survival-predictor:v1"
    command = concat([
      "--bucket", "webinar-containers-data",
      "--training", "part1/titanic/train.csv",
      "--new-passengers", "part1/titanic/test.csv",
      "--predictions", "part1/titanic/output.csv"
    ])
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group": "/webinar-containers/titanic-survival-predictor-logs",
        "awslogs-region": "eu-west-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }])
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/webinar-containers/titanic-survival-predictor-logs"
  retention_in_days = 1
}
