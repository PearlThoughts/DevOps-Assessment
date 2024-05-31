provider "aws" {
  region = "YOUR_REGION"
}

resource "aws_ecr_repository" "notification_api" {
  name = "notification-api"
}

resource "aws_ecr_repository" "email_sender" {
  name = "email-sender"
}

output "notification_api_repo_url" {
  value = aws_ecr_repository.notification_api.repository_url
}

output "email_sender_repo_url" {
  value = aws_ecr_repository.email_sender.repository_url
}
