resource "aws_appautoscaling_target" "notification_tg" {
  max_capacity       = 3
  min_capacity       = 1   
  resource_id        = "service/${aws_ecs_cluster.assessment.name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_up" {
  name               = "${var.app_name}-scale-up"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.notification_tg.resource_id
  scalable_dimension = aws_appautoscaling_target.notification_tg.scalable_dimension
  service_namespace  = aws_appautoscaling_target.notification_tg.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      scaling_adjustment          = 1
      metric_interval_lower_bound = 0
    }
  }
}

resource "aws_appautoscaling_policy" "scale_down" {
  name               = "${var.app_name}-scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.notification_tg.resource_id
  scalable_dimension = aws_appautoscaling_target.notification_tg.scalable_dimension
  service_namespace  = aws_appautoscaling_target.notification_tg.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      scaling_adjustment           = -1
      metric_interval_upper_bound  = 0
    }
  }
}


