data "aws_ecs_task_definition" "latest" {
  for_each = var.services

  task_definition = "${local.prefix}-${each.value.name}"
  depends_on      = [aws_ecs_task_definition.service_tasks]
}
