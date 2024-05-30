resource "aws_secretsmanager_secret" "db_password" {
  name        = "db_password"
  description = "Database password for the Notification Service"
}

resource "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    password = "OUR_DB_PASSWORD_HERE"
  })
}
