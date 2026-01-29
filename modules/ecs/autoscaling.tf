resource "aws_appautoscaling_target" "ecs_target_scaling" {
  for_each   = { for k, v in var.services : k => v if v.autoscaling != null }
  depends_on = [aws_ecs_service.services]

  max_capacity       = each.value.autoscaling.max_capacity
  min_capacity       = each.value.autoscaling.min_capacity
  resource_id        = "service/${local.prefix}-backend/${local.prefix}-${each.value.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_out" {
  for_each = { for k, v in var.services : k => v if v.autoscaling != null }

  name               = "target-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_scaling[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_scaling[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_scaling[each.key].service_namespace

  dynamic "target_tracking_scaling_policy_configuration" {
    for_each = each.value.autoscaling.type == "CPU" ? [1] : []
    content {
      target_value = each.value.autoscaling.target
      predefined_metric_specification {
        predefined_metric_type = "ECSServiceAverageCPUUtilization"
      }
      scale_out_cooldown = each.value.autoscaling.scale_out_cooldown
      scale_in_cooldown  = each.value.autoscaling.scale_in_cooldown
    }
  }

  dynamic "target_tracking_scaling_policy_configuration" {
    for_each = each.value.autoscaling.type == "MEMORY" ? [1] : []
    content {
      target_value = each.value.autoscaling.target
      predefined_metric_specification {
        predefined_metric_type = "ECSServiceAverageMemoryUtilization"
      }
      scale_out_cooldown = each.value.autoscaling.scale_out_cooldown
      scale_in_cooldown  = each.value.autoscaling.scale_in_cooldown
    }
  }
}
