output "ecs_cluster" {
  value = aws_ecs_cluster.main.name
}

output "ecr_repositories" {
  value = aws_ecr_repository.services_repos
}

output "ecs_services" {
  value = aws_ecs_service.services
}

output "load_balancer" {
  value = var.load_balancer != null ? aws_lb.this[0] : null
}

output "alb_security_group" {
  value = var.load_balancer != null ? aws_security_group.alb_security_group : null
}

output "services_securitu_group" {
  value = aws_security_group.services_security_group
}
