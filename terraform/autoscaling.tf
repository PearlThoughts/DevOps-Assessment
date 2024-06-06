resource "aws_appautoscaling_target" "api_service_scaling_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.notification_cluster.name}/${aws_ecs_service.notification_api_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.min_task_count
  max_capacity       = var.max_task_count
}

resource "aws_appautoscaling_policy" "api_service_scaling_policy" {
  name                   = "api-service-cpu-scaling-policy"
  resource_id            = aws_appautoscaling_target.api_service_scaling_target.resource_id
  scalable_dimension     = aws_appautoscaling_target.api_service_scaling_target.scalable_dimension
  service_namespace      = aws_appautoscaling_target.api_service_scaling_target.service_namespace

  policy_type            = "TargetTrackingScaling"
  target_tracking_scaling_policy_configuration {
    target_value          = var.target_cpu_utilization
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown     = 300
    scale_out_cooldown    = 300
  }
}

resource "aws_appautoscaling_target" "email_service_scaling_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.notification_cluster.name}/${aws_ecs_service.email_sender_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.min_task_count
  max_capacity       = var.max_task_count
}

resource "aws_appautoscaling_policy" "email_service_scaling_policy" {
  name                   = "email-service-cpu-scaling-policy"
  resource_id            = aws_appautoscaling_target.email_service_scaling_target.resource_id
  scalable_dimension     = aws_appautoscaling_target.email_service_scaling_target.scalable_dimension
  service_namespace      = aws_appautoscaling_target.email_service_scaling_target.service_namespace

  policy_type            = "TargetTrackingScaling"
  target_tracking_scaling_policy_configuration {
    target_value          = var.target_cpu_utilization
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown     = 300
    scale_out_cooldown    = 300
  }
}

