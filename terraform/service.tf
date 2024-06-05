variable "cluster_name" {}
variable "ecr_repo_name" {}
variable "email_secret" {}
variable "subnets" {
  type = list(string)
}
variable "security_group" {
  type = string
}

resource "aws_ecs_task_definition" "notification_api" {
  family                   = "notification-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([{
    name      = "notification-api"
    image     = "${aws_ecr_repository.notification_api.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
    environment = [
      {
        name  = "EMAIL_SECRET"
        value = var.email_secret
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/notification-api"
        awslogs-region        = "us-west-2"
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

resource "aws_ecs_service" "notification_api" {
  name            = "notification-api"
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.notification_api.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = var.subnets
    security_groups = [var.security_group]
  }
}

resource "aws_ecs_task_definition" "email_sender" {
  family                   = "email-sender"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([{
    name      = "email-sender"
    image     = "${aws_ecr_repository.email_sender.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
    environment = [
      {
        name  = "EMAIL_SECRET"
        value = var.email_secret
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/email-sender"
        awslogs-region        = "us-west-2"
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

resource "aws_ecs_service" "email_sender" {
  name            = "email-sender"
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.email_sender.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = var.subnets
    security_groups = [var.security_group]
  }
}

output "service_name" {
  value = aws_ecs_service.notification_api.name
}
