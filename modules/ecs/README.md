# Module: ECS
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.scale_out](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.ecs_target_scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_ecr_lifecycle_policy.services_repos_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.services_repos](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecs_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.services](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.service_tasks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.services_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_execution_role_policy_base](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.task_role_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.task_role_global](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.listeners](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.service_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.service_tgs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.alb_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.services_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_service_discovery_private_dns_namespace.ecs_namespace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_private_dns_namespace) | resource |
| [aws_service_discovery_service.ecs_services](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_service) | resource |
| [aws_vpc_security_group_egress_rule.alb_egress_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.services_egress_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.alb_egress_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.services_ingress_from_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.services_ingress_from_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_ecs_task_definition.latest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_task_definition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment, for creating the prefix | `string` | n/a | yes |
| <a name="input_global_iam"></a> [global\_iam](#input\_global\_iam) | Global IAM policies to apply to all services | <pre>object({<br/>    managed_policies = optional(list(string), [])<br/>  })</pre> | <pre>{<br/>  "managed_policies": []<br/>}</pre> | no |
| <a name="input_load_balancer"></a> [load\_balancer](#input\_load\_balancer) | Load balancer configuration | <pre>object({<br/>    listeners = map(object({<br/>      port     = number<br/>      protocol = string<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | The IDs of the Private Subnets | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of the project, for creating the prefix | `string` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | The IDs of the Public Subnets | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Name of the AWS region | `any` | n/a | yes |
| <a name="input_services"></a> [services](#input\_services) | Map of services to deploy | <pre>map(object({<br/>    name                       = string<br/>    dns_name                   = string<br/>    cpu                        = optional(number, 512)<br/>    memory                     = optional(number, 1024)<br/>    container_port             = optional(number, 8000)<br/>    environment_variables      = optional(list(object({ name = string, value = string })), [])<br/>    capacity_provider_strategy = optional(string, "ALL_ONDEMAND")<br/>    autoscaling = optional(object({<br/>      type               = string<br/>      target             = number<br/>      min_capacity       = number<br/>      max_capacity       = number<br/>      scale_out_cooldown = optional(number, 200)<br/>      scale_in_cooldown  = optional(number, 200)<br/>    }))<br/>    iam = optional(object({<br/>      managed_policies = optional(list(string), [])<br/>    }), null)<br/>    load_balancer = optional(object({<br/>      rule = object({<br/>        type   = string<br/>        values = set(string)<br/>      })<br/>      healthcheck = object({<br/>        path                = string<br/>        healthy_threshold   = optional(number, 2)<br/>        unhealthy_threshold = optional(number, 10)<br/>      })<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The CIDR of the VPC | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_security_group"></a> [alb\_security\_group](#output\_alb\_security\_group) | n/a |
| <a name="output_ecr_repositories"></a> [ecr\_repositories](#output\_ecr\_repositories) | n/a |
| <a name="output_ecs_cluster"></a> [ecs\_cluster](#output\_ecs\_cluster) | n/a |
| <a name="output_ecs_services"></a> [ecs\_services](#output\_ecs\_services) | n/a |
| <a name="output_load_balancer"></a> [load\_balancer](#output\_load\_balancer) | n/a |
| <a name="output_services_securitu_group"></a> [services\_securitu\_group](#output\_services\_securitu\_group) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
