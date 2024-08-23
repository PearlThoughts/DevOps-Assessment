resource "aws_application_auto_scaling_target" "notification" {
  max_capacity = 10
  min_capacity = 1
  resource_id   = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.notification.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_application_auto_scaling_policy" "scale_up" {
  name                   = "scale-up"
  policy_type            = "TargetTrackingScaling"
  scaling_target         = aws_application_auto_scaling_target.notification.id
  adjustment_type        = "ChangeInCapacity"
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70
  }
}

resource "aws_application_auto_scaling_policy" "scale_down" {
  name                   = "scale-down"
  policy_type            = "TargetTrackingScaling"
  scaling_target         = aws_application_auto_scaling_target.notification.id
  adjustment_type        = "ChangeInCapacity"
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70
  }
}
