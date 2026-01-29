# ----------------------
# Service Discovery
# ----------------------

resource "aws_service_discovery_private_dns_namespace" "ecs_namespace" {
  name        = "${local.prefix}.local"
  description = "Service discovery namespace for ECS services"
  vpc         = var.vpc_id
}

resource "aws_service_discovery_service" "ecs_services" {
  for_each = var.services

  name = each.value.name
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.ecs_namespace.id
    dns_records {
      type = "A"
      ttl  = 10
    }
    routing_policy = "MULTIVALUE"
  }
}

# ----------------------
# Load Balancer
# ----------------------

resource "aws_lb_target_group" "service_tgs" {
  for_each = { for k, v in var.services : k => v if v.load_balancer != null }

  name        = "${local.prefix}-${each.value.name}-tg"
  port        = each.value.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = each.value.load_balancer.healthcheck.path
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }
}

resource "aws_lb" "this" {
  lifecycle {
    create_before_destroy = false
  }
  count = var.load_balancer != null ? 1 : 0

  name               = "${local.prefix}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group[0].id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_listener" "listeners" {
  for_each = var.load_balancer != null ? {
    for k, v in var.load_balancer.listeners : k => v
  } : {}

  lifecycle {
    create_before_destroy = false
  }

  load_balancer_arn = aws_lb.this[0].arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "No routes matched"
      status_code  = "404"
    }
  }

}

resource "aws_lb_listener_rule" "service_rules" {
  for_each = {
    for pair in flatten([
      for svc_key, svc in var.services : [
        for listener_key, listener in var.load_balancer.listeners : {
          service_key  = svc_key
          listener_key = listener_key
          service      = svc
        } if svc.load_balancer != null
      ] if var.load_balancer != null
    ]) : "${pair.service_key}-${pair.listener_key}" => pair
  }

  listener_arn = aws_lb_listener.listeners[each.value.listener_key].arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_tgs[each.value.service_key].arn
  }
  dynamic "condition" {
    for_each = each.value.service.load_balancer.rule.type == "PATH" ? [1] : []
    content {
      path_pattern {
        values = each.value.service.load_balancer.rule.values
      }
    }
  }
  dynamic "condition" {
    for_each = each.value.service.load_balancer.rule.type == "HOST" ? [1] : []
    content {
      host_header {
        values = each.value.service.load_balancer.rule.values
      }
    }
  }
}

# ----------------------
# ALB Security Group
# ----------------------

resource "aws_security_group" "alb_security_group" {
  count = var.load_balancer != null ? 1 : 0

  name   = "${local.prefix}-alb-sg"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "alb_egress_rule" {
  count = var.load_balancer != null ? 1 : 0

  security_group_id = aws_security_group.alb_security_group[0].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
resource "aws_vpc_security_group_ingress_rule" "alb_egress_rule" {
  for_each = var.load_balancer != null ? {
    for k, v in var.load_balancer.listeners : k => v
  } : {}

  security_group_id = aws_security_group.alb_security_group[0].id
  cidr_ipv4         = "0.0.0.0/0"
  to_port           = each.value.port
  from_port         = each.value.port
  ip_protocol       = "tcp"
}

# ----------------------
# ECS Security Groups
# ----------------------

resource "aws_security_group" "services_security_group" {
  name        = "${local.prefix}-services-sg"
  description = "Security Group for Services"
  vpc_id      = var.vpc_id
}
resource "aws_vpc_security_group_egress_rule" "services_egress_sg" {
  security_group_id = aws_security_group.services_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "services_ingress_from_vpc" {
  security_group_id = aws_security_group.services_security_group.id
  cidr_ipv4         = var.vpc_cidr
  ip_protocol       = "-1"
}
resource "aws_vpc_security_group_ingress_rule" "services_ingress_from_alb" {
  count = var.load_balancer != null ? 1 : 0

  security_group_id            = aws_security_group.services_security_group.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.alb_security_group[0].id
}
