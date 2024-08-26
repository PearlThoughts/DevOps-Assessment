resource "aws_cloudwatch_log_group" "notification" {
  name              = "/ecs/notification"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "email_sender" {
  name              = "/ecs/email-sender"
  retention_in_days = 14
}

