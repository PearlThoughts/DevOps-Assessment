resource "aws_ecr_repository" "notification_api" {
  name = "notification-api"
}

resource "aws_ecr_repository" "email_sender" {
  name = "email-sender"
}

output "repo_name" {
  value = aws_ecr_repository.notification_api.name
}
