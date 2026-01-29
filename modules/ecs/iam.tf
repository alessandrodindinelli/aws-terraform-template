# ----------------------
# Task Execution Role
# ----------------------

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${local.prefix}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy_base" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "services_role" {
  for_each = var.services

  name = "${local.prefix}-${each.value.name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# ----------------------
# Task Role
# ----------------------

resource "aws_iam_role_policy_attachment" "task_role_default" {
  for_each = {
    for pair in flatten([
      for svc_key, svc in var.services : [
        for policy_arn in svc.iam.managed_policies : {
          policy_arn = policy_arn
          svc_key    = svc_key
        }
      ] if svc.iam != null
    ]) : "${pair.svc_key}-${pair.policy_arn}" => pair
  }
  policy_arn = each.value.policy_arn
  role       = aws_iam_role.services_role[each.value.svc_key].name
}

resource "aws_iam_role_policy_attachment" "task_role_global" {
  for_each = {
    for pair in flatten([
      for svc_key, svc in var.services : [
        for policy_arn in var.global_iam.managed_policies : {
          policy_arn = policy_arn
          svc_key    = svc_key
        }
      ] if var.global_iam != null
    ]) : "${pair.svc_key}-${pair.policy_arn}" => pair
  }

  policy_arn = each.value.policy_arn
  role       = aws_iam_role.services_role[each.value.svc_key].name
}
