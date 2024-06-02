# appmesh.tf
resource "aws_appmesh_mesh" "service_mesh" {
  name = "notification-service-mesh"
}

resource "aws_appmesh_virtual_service" "notification_service" {
  name      = "notification-api.${aws_appmesh_mesh.service_mesh.id}.local"
  mesh_name = aws_appmesh_mesh.service_mesh.id

  spec {
    provider {
      virtual_node {
        virtual_node_name = aws_appmesh_virtual_node.notification_node.id
      }
    }
  }
}

resource "aws_appmesh_virtual_service" "email_sender_service" {
  name      = "email-sender.${aws_appmesh_mesh.service_mesh.id}.local"
  mesh_name = aws_appmesh_mesh.service_mesh.id

  spec {
    provider {
      virtual_node {
        virtual_node_name = aws_appmesh_virtual_node.email_sender_node.id
      }
    }
  }
}

resource "aws_appmesh_virtual_node" "notification_node" {
  name      = "notification-api"
  mesh_name = aws_appmesh_mesh.service_mesh.id

  spec {
    listener {
      port_mapping {
        port     = 3000
        protocol = "http"
      }
    }

    service_discovery {
      cloud_map {
        namespace_name = aws_servicediscovery_private_dns_namespace.main.name
        service_name   = aws_servicediscovery_service.notification_service.name
      }
    }
  }
}

resource "aws_appmesh_virtual_node" "email_sender_node" {
  name      = "email-sender"
  mesh_name = aws_appmesh_mesh.service_mesh.id

  spec {
    listener {
      port_mapping {
        port     = 80
        protocol = "http"
      }
    }

    service_discovery {
      cloud_map {
        namespace_name = aws_servicediscovery_private_dns_namespace.main.name
        service_name   = aws_servicediscovery_service.email_sender_service.name
      }
    }
  }
}
