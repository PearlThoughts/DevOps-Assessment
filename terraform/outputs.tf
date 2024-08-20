output "ecs_cluster_id" {
  description = "ECS Cluster ID"
  value       = aws_ecs_cluster.main.id
}

output "sqs_queue_url" {
  description = "SQS Queue URL"
  value       = aws_sqs_queue.notification_queue.id
}
