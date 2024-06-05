resource "aws_secretsmanager_secret" "email_credentials" {
  name = "email_credentials"
}

resource "aws_secretsmanager_secret_version" "email_credentials" {
  secret_id = aws_secretsmanager_secret.email_credentials.id
  secret_string = jsondecode({
    smtp_user = "your_smtp_user"
    smtp_user = "your_smtp_password"
  })
}

output "email_secret_arn" {
  value = aws_secretsmanager_secret.email_credentials.arn
}
