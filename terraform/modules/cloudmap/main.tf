resource "aws_service_discovery_private_dns_namespace" "private_dns_namespace" {
  name        = var.namespace_name
  vpc         = var.vpc_id
  description = var.description
}

resource "aws_service_discovery_service" "notification" {
  name = var.service_name
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.private_dns_namespace.id
    dns_records {
      type = "A"
      ttl  = var.ttl
    }
  }
  health_check_custom_config {
    failure_threshold = var.failure_threshold
  }
}
output "namespace_id" {
  description = "ID of the Cloud Map namespace"
  value       = aws_service_discovery_private_dns_namespace.private_dns_namespace.id
}

output "service_id" {
  description = "ID of the Cloud Map service"
  value       = aws_service_discovery_service.notification.id
}
