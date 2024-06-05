resource "aws_ecs_cluster" "main" {
  name = "notification-cluster"
}

output "cluster_name" {
  value = aws_ecs_cluster.main.name
}
