resource "aws_mwaa_environment" "mwaa_environment" {
  airflow_configuration_options = {
    "core.default_task_retries" = 16
    "core.parallelism"          = 1
  }

  dag_s3_path           = "dags"
  execution_role_arn    = aws_iam_role.execution_role.arn
  name                  = "titanic_demo"
  webserver_access_mode = "PUBLIC_ONLY"

  network_configuration {
    security_group_ids = [aws_security_group.mwaa.id]
    subnet_ids         = aws_subnet.private_subnets.*.id
  }

  source_bucket_arn = aws_s3_bucket.airflow_bucket.arn
}
