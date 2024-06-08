resource "aws_secretsmanager_secret" "notification_api_secret" {
  name = "notification-api-secret"
  description = "Secret for Notification API"

  secret_string = jsonencode({
    db_username = "notification_user"
    db_password = "notification_password"
  })
}

resource "aws_secretsmanager_secret" "email_sender_secret" {
  name = "email-sender-secret"
  description = "Secret for Email Sender"

  secret_string = jsonencode({
    smtp_username = "smtp_user"
    smtp_password = "smtp_password"
  })
}
