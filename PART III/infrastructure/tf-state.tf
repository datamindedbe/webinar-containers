terraform {
  backend "s3" {
    bucket         = "webinar-containers-terraform-state"
    region         = "eu-west-1"
    encrypt        = "true"
    key            = "webinar-containers.tfstate"
    dynamodb_table = "webinar-containers-terraform-statelock"
  }
}