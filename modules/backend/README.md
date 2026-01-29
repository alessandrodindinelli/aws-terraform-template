# Module: Backend
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tf_lock_table"></a> [tf\_lock\_table](#module\_tf\_lock\_table) | terraform-aws-modules/dynamodb-table/aws | ~> 4.4.0 |
| <a name="module_tf_state_bucket"></a> [tf\_state\_bucket](#module\_tf\_state\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 4.11.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project"></a> [project](#input\_project) | Name of the project, for creating the prefix | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | n/a |
| <a name="output_dynamodb_table_name"></a> [dynamodb\_table\_name](#output\_dynamodb\_table\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
