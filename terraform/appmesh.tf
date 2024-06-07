resource "aws_appmesh_mesh" "service_mesh" {
  name = "notification-sm"
}

resource "aws_appmesh_virtual_service" "notification_service" {
  name      = "notification-api.local"
  mesh_name = aws_appmesh_mesh.service_mesh.name

  spec {
    provider {
      virtual_node {
        virtual_node_name = aws_appmesh_virtual_node.notification_node.name
      }
    }
  }
}

resource "aws_appmesh_virtual_service" "email_sender_service" {
  name      = "email-sender.local"
  mesh_name = aws_appmesh_mesh.service_mesh.name

  spec {
    provider {
      virtual_node {
        virtual_node_name = aws_appmesh_virtual_node.email_sender_node.name
      }
    }
  }
}

resource "aws_appmesh_virtual_node" "notification_node" {
  name      = "notification-api"
  mesh_name = aws_appmesh_mesh.service_mesh.name

  spec {
    listener {
      port_mapping {
        port     = 3000
        protocol = "http"
      }
    }
  }
}

resource "aws_appmesh_virtual_node" "email_sender_node" {
  name      = "email-sender"
  mesh_name = aws_appmesh_mesh.service_mesh.name

  spec {
    listener {
      port_mapping {
        port     = 80
        protocol = "http"
      }
    }
  }
}
