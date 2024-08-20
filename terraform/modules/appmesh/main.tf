resource "aws_appmesh_mesh" "service_mesh" {
  name = var.mesh_name
}

resource "aws_appmesh_virtual_node" "service_mesh_virtualnode" {
  mesh_name = aws_appmesh_mesh.service_mesh.name
  name      = var.virtual_node_name

  spec {
    listener {
      port_mapping {
        port     = var.port
        protocol = var.protocol
      }
    }
    service_discovery {
      aws_cloud_map {
        namespace_name = var.namespace_name
        service_name   = var.service_name
      }
    }
  }
}

resource "aws_appmesh_virtual_service" "this" {
  mesh_name = aws_appmesh_mesh.service_mesh.name
  name      = var.virtual_service_name

  spec {
    provider {
      virtual_node {
        virtual_node_name = aws_appmesh_virtual_node.service_mesh_virtualnode.name
      }
    }
  }
}
