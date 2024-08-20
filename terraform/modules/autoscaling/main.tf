resource "aws_appautoscaling_target" "notification_scaling_target" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "notification_scaling_policy" {
  name               = var.policy_name
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.notification_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.notification_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.notification_scaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = var.target_value

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}
