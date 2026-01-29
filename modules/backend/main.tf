data "aws_caller_identity" "current" {}

module "tf_state_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.11.0"

  bucket = "${local.prefix}-${data.aws_caller_identity.current.account_id}-tf-state"
  versioning = {
    enabled = true
  }
  force_destroy = false
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = local.common_tags
}

module "tf_lock_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 4.4.0"

  name                        = "${local.prefix}-tf-lock"
  deletion_protection_enabled = true
  billing_mode                = "PAY_PER_REQUEST"
  hash_key                    = "LockID"
  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]

  tags = local.common_tags
}
