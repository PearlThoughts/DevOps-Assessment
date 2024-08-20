resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = "notification.local"
  description = "Private DNS namespace for notification services"
  vpc         = aws_vpc.main.id
}

resource "aws_service_discovery_service" "notification_service" {
  name = "notification_api"
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id
    dns_records {
      ttl  = 10
      type = "A"
    }
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "email_sender_service" {
  name = "email_sender"
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id
    dns_records {
      ttl  = 10
      type = "A"
    }
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}
