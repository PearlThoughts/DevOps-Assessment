# cloudmap.tf
resource "aws_servicediscovery_private_dns_namespace" "main" {
  name        = "notification.local"
  description = "Private DNS namespace for notification services"
  vpc         = aws_vpc.main.id
}

resource "aws_servicediscovery_service" "notification_service" {
  name = "notification-api"
  namespace_id = aws_servicediscovery_private_dns_namespace.main.id
  dns_config {
    dns_records {
      ttl  = 10
      type = "A"
    }
    namespace_id = aws_servicediscovery_private_dns_namespace.main.id
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_servicediscovery_service" "email_sender_service" {
  name = "email-sender"
  namespace_id = aws_servicediscovery_private_dns_namespace.main.id
  dns_config {
    dns_records {
      ttl  = 10
      type = "A"
    }
    namespace_id = aws_servicediscovery_private_dns_namespace.main.id
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}
