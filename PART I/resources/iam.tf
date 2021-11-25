resource "aws_iam_role" "datafy_project" {
  name               = "titanic-survival-predictor-datafy-role"
  assume_role_policy = data.aws_iam_policy_document.datafy_project_assume_role.json
}

resource "aws_iam_role_policy" "datafy_project" {
  role   = aws_iam_role.datafy_project.name
  policy = data.aws_iam_policy_document.datafy_project_s3_policy.json
}

data "aws_iam_policy_document" "datafy_project_assume_role" {
 statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect = "Allow"

    condition {
      test     = "StringLike"
      variable = "${replace(var.aws_iam_openid_connect_provider_url, "https://", "")}:sub"
      values = ["system:serviceaccount:${var.env_name}:test-webinar-containers-*"]
    }

    principals {
      identifiers = [var.aws_iam_openid_connect_provider_arn]
      type = "Federated"
    }
  }
}

data "aws_iam_policy_document" "datafy_project_s3_policy" {
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

variable "env_name" {}
variable "aws_iam_openid_connect_provider_url" {}
variable "aws_iam_openid_connect_provider_arn" {}
