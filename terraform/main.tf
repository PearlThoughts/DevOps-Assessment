provider "aws" {
  region = "eu-north-1"
}

resource "aws_cloudwatch_log_group" "notification_api" {
  name              = "/ecs/notification-api"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "email_sender" {
  name              = "/ecs/email-sender"
  retention_in_days = 7
}

resource "aws_sqs_queue" "notification_queue" {
  name = "notification-queue"
}
