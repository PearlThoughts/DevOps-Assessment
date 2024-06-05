variable "service_name" {
  description = "The name of the ECS service"
}

variable "cluster_name" {
  description = "The name of the ECS cluster"
}

variable "service_namespace" {
  description = "The namespace of the service for autoscaling"
  default     = "ecs"
}

resource "aws_appautoscaling_target" "service" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_up" {
  name              = "scale-up"
  scaling_target_id = aws_appautoscaling_target.service.id
  policy_type       = "StepScaling"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"
    step_adjustments {
      scaling_adjustment          = 1
      metric_interval_lower_bound = 0
    }
  }
}

resource "aws_appautoscaling_policy" "scale_down" {
  name              = "scale-down"
  scaling_target_id = aws_appautoscaling_target.service.id
  policy_type       = "StepScaling"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"
    step_adjustments {
      scaling_adjustment          = -1
      metric_interval_upper_bound = 0
    }
  }
}
