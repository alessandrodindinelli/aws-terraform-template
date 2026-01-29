resource "aws_ecs_task_definition" "service_tasks" {
  for_each = var.services

  family                   = "${local.prefix}-${each.value.name}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.services_role[each.key].arn

  container_definitions = jsonencode(
    concat(
      [
        {
          name        = each.value.name
          image       = "${aws_ecr_repository.services_repos[each.key].repository_url}:latest"
          environment = each.value.environment_variables
          portMappings = [{
            containerPort = each.value.container_port
            protocol      = "tcp"
            name          = each.value.name
          }],
          logConfiguration = {
            logDriver = "awslogs",
            options = {
              "awslogs-create-group"  = "true"
              "awslogs-region"        = var.region
              "awslogs-group"         = "/ecs/${local.prefix}-${each.value.name}"
              "awslogs-stream-prefix" = "ecs"
              "mode"                  = "non-blocking"
              "max-buffer-size"       = "25m"
            }
          }
        }
      ]
    )
  )
}
