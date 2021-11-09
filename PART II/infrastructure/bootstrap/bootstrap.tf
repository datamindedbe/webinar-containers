provider "aws" {
  region = "eu-west-1"
  allowed_account_ids = ["130966031144"]
}

resource "aws_kms_alias" "terraform_state_key_alias" {
  name          = "alias/webinar-containers-terraform-state-key"
  target_key_id = aws_kms_key.terraform_state_key.id
}

resource "aws_kms_key" "terraform_state_key" {
  description             = "Key to encrypt objects in s3 terraform state buckets"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = {
    Terraform   = "true"
    Application = "webinar-containers"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "webinar-containers-terraform-state"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.terraform_state_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = {
    Name        = "webinar-containers-terraform-state"
    Terraform   = "true"
    Application = "webinar-containers"
  }
}


resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "terraform_state" {
  statement {
    sid     = "AllowSSLRequestsOnly"
    actions = ["s3:*"]
    effect  = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      values   = ["false"]
      variable = "aws:SecureTransport"
    }
    resources = [
      "${aws_s3_bucket.terraform_state.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "terraform_state" {
  bucket     = aws_s3_bucket.terraform_state.id
  policy     = data.aws_iam_policy_document.terraform_state.json
  depends_on = [aws_s3_bucket_public_access_block.terraform_state]
}

resource "aws_dynamodb_table" "terraform_statelock" {
  name         = "webinar-containers-terraform-statelock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity,
    ]
  }

  point_in_time_recovery {
    enabled = false
  }

  server_side_encryption {
    enabled = false
  }

  tags = {
    Terraform   = "true"
    Application = "webinar-containers"
  }
}