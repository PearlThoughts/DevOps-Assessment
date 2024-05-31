resource "aws_ecs_cluster" "ecs-cluster" {
  name = var.aws_ecs_cluster_name
}

data "template_file" "demo_ecs_app" {
  template = file("./templates/demo_ecs_app.json.tpl")
  vars = {
    app_image      = aws_ecr_repository.demo_ecs_app.repository_url
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    tag            = var.tag
    name           = var.aws_ecr_repository
  }
}

