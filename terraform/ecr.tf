resource "aws_ecr_repository" "notification_api" {
  name = "notification-api"
}

resource "aws_ecr_repository" "email_sender" {
  name = "email-sender"
}
