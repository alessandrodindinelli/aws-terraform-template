resource "aws_ecs_service" "services" {
  for_each = var.services
  lifecycle {
    ignore_changes = [desired_count]
  }

  name            = "${local.prefix}-${each.value.name}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = data.aws_ecs_task_definition.latest[each.key].arn
  desired_count   = 0

  network_configuration {
    subnets          = var.private_subnet_ids
    assign_public_ip = false
    security_groups  = [aws_security_group.services_security_group.id]
  }

  dynamic "load_balancer" {
    for_each = each.value.load_balancer != null ? [1] : []
    content {
      target_group_arn = aws_lb_target_group.service_tgs[each.key].arn
      container_name   = each.value.name
      container_port   = each.value.container_port
    }
  }
  dynamic "capacity_provider_strategy" {
    for_each = each.value.capacity_provider_strategy == "ALL_ONDEMAND" ? [1] : []
    content {
      capacity_provider = "FARGATE"
      weight            = 1
    }
  }
  dynamic "capacity_provider_strategy" {
    for_each = each.value.capacity_provider_strategy == "ALL_SPOT" ? [1] : []
    content {
      capacity_provider = "FARGATE_SPOT"
      weight            = 1
    }
  }
  dynamic "capacity_provider_strategy" {
    for_each = each.value.capacity_provider_strategy == "SCALING_WITH_SPOT" ? [1] : []
    content {
      capacity_provider = "FARGATE"
      weight            = 0
      base              = try(each.value.autoscaling.min_capacity, null)
    }
  }
  dynamic "capacity_provider_strategy" {
    for_each = each.value.capacity_provider_strategy == "SCALING_WITH_SPOT" ? [1] : []
    content {
      capacity_provider = "FARGATE_SPOT"
      weight            = 1
      base              = 0
    }
  }

  service_connect_configuration {
    enabled = true

    service {
      port_name      = each.value.name
      discovery_name = "${each.value.name}-sc"

      client_alias {
        dns_name = each.value.dns_name
        port     = each.value.container_port
      }
    }
    namespace = aws_service_discovery_private_dns_namespace.ecs_namespace.arn
  }
  service_registries {
    registry_arn   = aws_service_discovery_service.ecs_services[each.key].arn
    container_name = each.value.name

  }
}
