resource "aws_ecs_cluster" "webinar_containers" {
  name               = "webinar-containers"
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "ingest_training" {
  family                   = "ingest_training"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions    = jsonencode([{
    name        = "ingest_training"
    networkMode = "awsvpc"
    cpu         = 256
    memory      = 512
    image      = "130966031144.dkr.ecr.eu-west-1.amazonaws.com/webinar-containers/titanic-predictor:v1"
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group": "/webinar-containers/titanic-predictor-logs",
        "awslogs-region": "eu-west-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }])
}

resource "aws_ecs_task_definition" "ingest_test" {
  family                   = "ingest_test"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions    = jsonencode([{
    name        = "ingest_test"
    networkMode = "awsvpc"
    cpu         = 256
    memory      = 512
    image      = "130966031144.dkr.ecr.eu-west-1.amazonaws.com/webinar-containers/titanic-predictor:v1"
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group": "/webinar-containers/titanic-predictor-logs",
        "awslogs-region": "eu-west-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }])
}

resource "aws_ecs_task_definition" "clean_training" {
  family                   = "clean_training"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions    = jsonencode([{
    name        = "clean_training"
    networkMode = "awsvpc"
    cpu         = 256
    memory      = 512
    image      = "130966031144.dkr.ecr.eu-west-1.amazonaws.com/webinar-containers/titanic-predictor:v1"
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group": "/webinar-containers/titanic-predictor-logs",
        "awslogs-region": "eu-west-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }])
}

resource "aws_ecs_task_definition" "clean_test" {
  family                   = "clean_test"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions    = jsonencode([{
    name        = "clean_test"
    networkMode = "awsvpc"
    cpu         = 256
    memory      = 512
    image      = "130966031144.dkr.ecr.eu-west-1.amazonaws.com/webinar-containers/titanic-predictor:v1"
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group": "/webinar-containers/titanic-predictor-logs",
        "awslogs-region": "eu-west-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }])
}

resource "aws_ecs_task_definition" "train_model" {
  family                   = "train_model"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions    = jsonencode([{
    name        = "train_model"
    networkMode = "awsvpc"
    cpu         = 256
    memory      = 512
    image      = "130966031144.dkr.ecr.eu-west-1.amazonaws.com/webinar-containers/titanic-predictor:v1"
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group": "/webinar-containers/titanic-predictor-logs",
        "awslogs-region": "eu-west-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }])
}

resource "aws_ecs_task_definition" "predict" {
  family                   = "predict"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions    = jsonencode([{
    name        = "predict"
    networkMode = "awsvpc"
    cpu         = 256
    memory      = 512
    image      = "130966031144.dkr.ecr.eu-west-1.amazonaws.com/webinar-containers/titanic-predictor:v1"
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group": "/webinar-containers/titanic-predictor-logs",
        "awslogs-region": "eu-west-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }])
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/webinar-containers/titanic-predictor-logs"
  retention_in_days = 1
}
