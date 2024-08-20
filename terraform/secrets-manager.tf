# Example of storing secrets
resource "aws_secretsmanager_secret" "notification_secret" {
  name        = "notification_secret"
  description = "Storing Secrets for Microservices"
}