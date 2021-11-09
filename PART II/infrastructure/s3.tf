resource "aws_s3_bucket" "terraform_state" {
  bucket = "webinar-containers-data"
  acl    = "private"
  tags = {
    Name        = "webinar-containers-data"
    Terraform   = "true"
    Application = "webinar-containers"
  }
}