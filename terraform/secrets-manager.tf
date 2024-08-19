
resource "aws_secretsmanager_secret" "email_service_secret" {
  name        = "email-service-credentials"
  description = "Stores the email service API credentials"
  recovery_window_in_days = 7
}


resource "aws_secretsmanager_secret_version" "email_service_secret_version" {
  secret_id = aws_secretsmanager_secret.email_service_secret.id

  secret_string = jsonencode({
    username = "your-email-service-username",  
    password = "your-email-service-password"   
  })
}
