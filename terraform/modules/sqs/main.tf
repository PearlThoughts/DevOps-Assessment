resource "aws_sqs_queue" "notification_queue" {
  name                      = "notification-queue"
  visibility_timeout_seconds = 30
}

output "sqs_queue_url" {
  value = aws_sqs_queue.notification_queue.url
}
