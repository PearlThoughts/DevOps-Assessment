resource "aws_appmesh_mesh" "service_mesh" {
  name = "service-mesh"
}

resource "aws_servicediscovery_private_dns_namespace" "service_namespace" {
  name        = "service.local"
  description = "Private DNS namespace for services"
  vpc         = var.vpc_id
}

resource "aws_appmesh_virtual_node" "notification_api_node" {
  mesh_name = aws_appmesh_mesh.service_mesh.name
  name      = "notification-api"

  spec {
    listener {
      port_mapping {
        port     = 80
        protocol = "http"
      }
    }

    service_discovery {
      aws_cloud_map {
        namespace_name = aws_servicediscovery_private_dns_namespace.service_namespace.name
        service_name   = "notification-api"
      }
    }
  }
}

resource "aws_appmesh_virtual_node" "email_sender_node" {
  mesh_name = aws_appmesh_mesh.service_mesh.name
  name      = "email-sender"

  spec {
    listener {
      port_mapping {
        port     = 80
        protocol = "http"
      }
    }

    service_discovery {
      aws_cloud_map {
        namespace_name = aws_servicediscovery_private_dns_namespace.service_namespace.name
        service_name   = "email-sender"
      }
    }
  }
}

