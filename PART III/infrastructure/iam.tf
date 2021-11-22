resource "aws_iam_role" "execution_role" {
  name               = "titanic-predictor-execution-role"
  assume_role_policy = data.aws_iam_policy_document.execution_role_assume_role.json
}

data "aws_iam_policy_document" "execution_role_assume_role" {
  statement {
    principals {
      identifiers = [
        "airflow-env.amazonaws.com",
        "airflow.amazonaws.com"
      ]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "execution_role" {
  role       = aws_iam_role.execution_role.name
  policy_arn = aws_iam_policy.execution_role.arn
}

resource "aws_iam_policy" "execution_role" {
  name   = "titanic-predictor-execution-role"
  path   = "/"
  policy = data.aws_iam_policy_document.execution_role.json
}

data "aws_iam_policy_document" "execution_role" {
  statement {
    sid       = ""
    actions   = ["airflow:PublishMetrics"]
    effect    = "Allow"
    resources = ["arn:aws:airflow:eu-west-1:130966031144:environment/titanic_demo"]
  }
  
  statement {
    sid       = ""
    actions   = ["s3:ListAllMyBuckets"]
    effect    = "Allow"
    resources = [
      aws_s3_bucket.airflow_bucket.arn,
      "${aws_s3_bucket.airflow_bucket.arn}/*"
    ]
  }

  statement {
    sid       = ""
    actions   = [
      "s3:GetObject*",
      "s3:GetBucket*",
      "s3:List*"
    ]
    effect    = "Allow"
    resources = [
      aws_s3_bucket.airflow_bucket.arn,
      "${aws_s3_bucket.airflow_bucket.arn}/*"
    ]
  }

  statement {
    sid       = ""
    actions   = ["logs:DescribeLogGroups"]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid       = ""
    actions   = ["cloudwatch:PutMetricData"]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid = ""
    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
      "sqs:SendMessage"
    ]
    effect    = "Allow"
    resources = ["arn:aws:sqs:eu-west-1:*:airflow-celery-*"]
  }
  
  statement {
    sid = ""
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt"
    ]
    effect        = "Allow"
    not_resources = ["arn:aws:kms:*:130966031144:key/*"]
    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values = [
        "sqs.eu-west-1.amazonaws.com"
      ]
    }
  }  

  statement {
    sid = ""
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:GetLogRecord",
      "logs:GetLogGroupFields",
      "logs:GetQueryResults",
      "logs:DescribeLogGroups"
    ]
    effect    = "Allow"
    resources = ["arn:aws:logs:eu-west-1:130966031144:log-group:airflow-titanic_demo-*"]
  }
}
