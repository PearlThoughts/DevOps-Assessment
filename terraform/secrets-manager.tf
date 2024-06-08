# Example of storing secrets
resource "aws_secretsmanager_secret" "example_secret" {
  name        = "example_secret"
  description = "An example secret"
}

resource "aws_secretsmanager_secret_version" "example_secret_version" {
  secret_id     = aws_secretsmanager_secret.example_secret.id
  secret_string = jsonencode({
    username = "example-username"
    password = "example-password"
  })
}
