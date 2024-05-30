resource "aws_appautoscaling_target" "notification_api" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.notification-cluster.name}/${aws_ecs_service.notification_api.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "notification_api_scaling_policy" {
  name               = "notification-api-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.notification_api.resource_id
  scalable_dimension = aws_appautoscaling_target.notification_api.scalable_dimension
  service_namespace  = aws_appautoscaling_target.notification_api.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = 70.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
