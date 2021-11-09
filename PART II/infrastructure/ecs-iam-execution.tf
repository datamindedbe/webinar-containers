resource "aws_iam_role" "execution_role" {
  name               = "titanic-survival-predictor-execution-role"
  assume_role_policy = data.aws_iam_policy_document.execution_role_assume_role.json
}

resource "aws_iam_role_policy_attachment" "execution_role_ecs_default_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.execution_role.name
}

data "aws_iam_policy_document" "execution_role_assume_role" {
  statement {
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}
