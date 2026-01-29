remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "${local.prefix}-${get_aws_account_id()}-tf-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "${local.prefix}-tf-lock"
    encrypt        = true
  }
}

locals {
  project     = "project-name"
  prefix      = "${local.project}-backend"
}
