locals {
  prefix = "${var.environment}-${var.project}"
  common_tags = {
    managedBy   = "terraform"
    environment = var.environment
  }
  ecs_services_array = [
    for name in var.ecs_services : "${local.prefix}-${name}"
  ]
  ecs_services_string = join(",", local.ecs_services_array)
}
