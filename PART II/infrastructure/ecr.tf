resource "aws_ecr_repository" "webinar_containers_repository" {
  name     = "webinar-containers/titanic-survival-predictor"
}

resource "aws_ecr_repository_policy" "webinar_containers_repository_policy" {
  repository = aws_ecr_repository.webinar_containers_repository.name
  policy     = data.aws_iam_policy_document.webinar_containers_repository_policy.json
}

data "aws_iam_policy_document" "webinar_containers_repository_policy" {
  statement {
    sid = "AllowToPullImages"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:GetRepositoryPolicy",
    ]
    principals {
      identifiers = ["arn:aws:iam::130966031144:root"]
      type        = "AWS"
    }
  }  
}