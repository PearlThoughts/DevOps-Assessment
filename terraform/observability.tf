# Define CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "notification_api" {
  name              = "/ecs/notification-api"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "email_sender" {
  name              = "/ecs/email-sender"
  retention_in_days = 30
}

# Define CloudWatch Alarms for CPU Utilization
resource "aws_cloudwatch_metric_alarm" "notification_api_high_cpu" {
  alarm_name          = "notification-api-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "This alarm triggers if the CPU utilization of the notification API exceeds 70% for 2 consecutive periods."
  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = module.service.notification_api_service_name
  }
}

resource "aws_cloudwatch_metric_alarm" "email_sender_high_cpu" {
  alarm_name          = "email-sender-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "This alarm triggers if the CPU utilization of the email sender service exceeds 70% for 2 consecutive periods."
  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = module.service.email_sender_service_name
  }
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "notification_service_dashboard" {
  dashboard_name = "NotificationServiceDashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric",
        x      = 0,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", var.cluster_name, "ServiceName", module.service.notification_api_service_name],
            [".", "MemoryUtilization", ".", ".", ".", "."]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = "us-west-2",
          period  = 300,
          stat    = "Average",
          title   = "Notification API CPU and Memory Utilization"
        }
      },
      {
        type   = "metric",
        x      = 0,
        y      = 7,
        width  = 12,
        height = 6,
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", var.cluster_name, "ServiceName", module.service.email_sender_service_name],
            [".", "MemoryUtilization", ".", ".", ".", "."]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = "us-west-2",
          period  = 300,
          stat    = "Average",
          title   = "Email Sender CPU and Memory Utilization"
        }
      }
    ]
  })
}
