resource "aws_appmesh_virtual_node" "notification_api" {
  name      = "notification-api-node"
  mesh_name = aws_appmesh_mesh.main.id
  spec {
    listener {
      port_mapping {
        port     = 80
        protocol = "http"
      }
    }
    service_discovery {
      cloud_map {
        service_name = aws_service_discovery_service.notification_api.name
        namespace_name = aws_service_discovery_private_dns_namespace.main.name
      }
    }
  }
}

resource "aws_appmesh_virtual_node" "email_sender" {
  name      = "email-sender-node"
  mesh_name = aws_appmesh_mesh.main.id
  spec {
    listener {
      port_mapping {
        port     = 80
        protocol = "http"
      }
    }
    service_discovery {
      cloud_map {
        service_name = aws_service_discovery_service.email_sender.name
        namespace_name = aws_service_discovery_private_dns_namespace.main.name
      }
    }
  }
}

resource "aws_appmesh_virtual_service" "notification_api" {
  name      = "notification-api"
  mesh_name = aws_appmesh_mesh.main.id
  spec {
    provider {
      virtual_node {
        virtual_node_name = aws_appmesh_virtual_node.notification_api.name
      }
    }
  }
}

resource "aws_appmesh_virtual_service" "email_sender" {
  name      = "email-sender"
  mesh_name = aws_appmesh_mesh.main.id
  spec {
    provider {
      virtual_node {
        virtual_node_name = aws_appmesh_virtual_node.email_sender.name
      }
    }
  }
}

resource "aws_appmesh_mesh" "main" {
  name = "main-mesh"
}

resource "aws_service_discovery_private_dns_namespace" "main" {
  name = "example.local"
  vpc  = module.vpc.vpc_id
}

resource "aws_service_discovery_service" "notification_api" {
  name = "notification-api"
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id
    dns_records {
      ttl  = 10
      type = "A"
    }
  }
}

resource "aws_service_discovery_service" "email_sender" {
  name = "email-sender"
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id
    dns_records {
      ttl  = 10
      type = "A"
    }
  }
}
