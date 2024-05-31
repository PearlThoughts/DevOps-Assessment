provider "aws" {
  region = "YOUR_REGION"
}

resource "aws_ecr_repository" "notification_api" {
  name = "notification-api"
}

resource "aws_ecr_repository" "email_sender" {
  name = "email-sender"
}

resource "aws_ecs_cluster" "main" {
  name = "notification-cluster"
}

resource "aws_ecs_task_definition" "notification_api" {
  family                = "notification-api-task"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "256"
  memory                = "512"

  container_definitions = jsonencode([{
    name  = "notification-api"
    image = aws_ecr_repository.notification_api.repository_url
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group" = "/ecs/notification-api"
        "awslogs-region" = "YOUR_REGION"
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}

resource "aws_ecs_task_definition" "email_sender" {
  family                = "email-sender-task"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "256"
  memory                = "512"

  container_definitions = jsonencode([{
    name  = "email-sender"
    image = aws_ecr_repository.email_sender.repository_url
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group" = "/ecs/email-sender"
        "awslogs-region" = "YOUR_REGION"
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}

resource "aws_ecs_service" "notification_api" {
  name            = "notification-api-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.notification_api.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["YOUR_SUBNET_ID"]
    security_groups = ["YOUR_SECURITY_GROUP_ID"]
  }

  health_check_grace_period_seconds = 60
  health_check {
    command     = ["CMD-SHELL", "curl -f http://localhost:3000/health || exit 1"]
    interval    = 30
    timeout     = 5
    retries     = 3
  }
}

resource "aws_ecs_service" "email_sender" {
  name            = "email-sender-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.email_sender.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["YOUR_SUBNET_ID"]
    security_groups = ["YOUR_SECURITY_GROUP_ID"]
  }
}

resource "aws_sqs_queue" "notification_queue" {
  name = "notification-queue"
}

output "notification_api_repo_url" {
  value = aws_ecr_repository.notification_api.repository_url
}

output "email_sender_repo_url" {
  value = aws_ecr_repository.email_sender.repository_url
}
