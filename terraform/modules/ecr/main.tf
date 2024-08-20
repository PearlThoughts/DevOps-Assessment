resource "aws_ecr_repository" "ecr_notification_app" {
  name                 = var.repository_name_notification
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}

resource "aws_ecr_repository" "ecr_email_service_app" {
  name                 = var.repository_name_email
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}

output "notification_repository_url" {
  value = aws_ecr_repository.ecr_notification_app.repository_url
}

output "email_service_repository_url" {
  value = aws_ecr_repository.ecr_email_service_app.repository_url
}
