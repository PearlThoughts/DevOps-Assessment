
resource "aws_appautoscaling_target" "notification_api" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/notification-cluster/notification-api-service"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "notification_api_scaling_policy" {
  name               = "notification-api-cpu-scaling"
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

resource "aws_appautoscaling_target" "email_sender" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/notification-cluster/email-sender-service"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "email_sender_scaling_policy" {
  name               = "email-sender-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.email_sender.resource_id
  scalable_dimension = aws_appautoscaling_target.email_sender.scalable_dimension
  service_namespace  = aws_appautoscaling_target.email_sender.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = 70.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
