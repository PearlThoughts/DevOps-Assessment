resource "aws_appautoscaling_target" "notification" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.notification.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "notification" {
  name                   = "cpu-target-tracking-scaling-policy"
  service_namespace      = "ecs"
  resource_id            = aws_appautoscaling_target.notification.resource_id
  scalable_dimension     = aws_appautoscaling_target.notification.scalable_dimension
  policy_type            = "TargetTrackingScaling"
  target_tracking_scaling_policy_configuration {
    target_value              = 70.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

resource "aws_appautoscaling_target" "email_sender" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.email_sender.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "email_sender" {
  name                   = "cpu-target-tracking-scaling-policy"
  service_namespace      = "ecs"
  resource_id            = aws_appautoscaling_target.email_sender.resource_id
  scalable_dimension     = aws_appautoscaling_target.email_sender.scalable_dimension
  policy_type            = "TargetTrackingScaling"
  target_tracking_scaling_policy_configuration {
    target_value              = 70.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

