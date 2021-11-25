resource "aws_s3_bucket" "airflow_bucket" {
  bucket = "webinar-containers-airflow"
  acl    = "private"
  versioning {
    enabled = true
  }
  tags = {
    Name        = "webinar-containers-airflow"
    Terraform   = "true"
    Application = "webinar-containers"
  }
}

resource "aws_s3_bucket_public_access_block" "airflow_bucket" {
  bucket                  = aws_s3_bucket.airflow_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "webinar-containers-data"
  acl    = "private"
  tags = {
    Name        = "webinar-containers-data"
    Terraform   = "true"
    Application = "webinar-containers"
  }
}