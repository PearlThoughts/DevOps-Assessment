resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/notification-service"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "notification_api_log_stream" {
  name           = "notification-api"
  log_group_name = aws_cloudwatch_log_group.ecs_log_group.name
}

resource "aws_cloudwatch_log_stream" "email_sender_log_stream" {
  name           = "email-sender"
  log_group_name = aws_cloudwatch_log_group.ecs_log_group.name
}

