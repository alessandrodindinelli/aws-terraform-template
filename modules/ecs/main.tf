resource "aws_ecs_cluster" "main" {
  name = "${local.prefix}-backend"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  service_connect_defaults {
    namespace = aws_service_discovery_private_dns_namespace.ecs_namespace.arn
  }

  tags = local.common_tags
}
