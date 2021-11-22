resource "aws_iam_role" "task_role" {
  name               = "titanic-predictor-task-role"
  assume_role_policy = data.aws_iam_policy_document.task_role_assume_role.json
}

resource "aws_iam_role_policy" "task_role_s3_policy" {
  role   = aws_iam_role.task_role.name
  policy = data.aws_iam_policy_document.task_role_s3_policy.json
}

data "aws_iam_policy_document" "task_role_assume_role" {
  statement {
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "task_role_s3_policy" {
  statement {
    actions   = [
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = ["arn:aws:s3:::webinar-containers-data/*"]
  }
  statement {
    actions   = [
      "s3:ListBucket",
    ]
    resources = ["arn:aws:s3:::webinar-containers-data"]
  }
}

