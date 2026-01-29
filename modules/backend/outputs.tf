output "bucket_name" {
  value = module.tf_state_bucket.s3_bucket_id
}

output "dynamodb_table_name" {
  value = module.tf_lock_table.dynamodb_table_id
}
