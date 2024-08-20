# Define the ECS cluster
resource "aws_ecs_cluster" "ecs_cluster01" {
  name = var.cluster_name
}
# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "ecs_notification_api" {
  name              = "/ecs/notification-api"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "ecs_email_sender" {
  name              = "/ecs/email-sender"
  retention_in_days = 7
}

# ECS Task Definition for Notification API
resource "aws_ecs_task_definition" "notification_task" {
  family                   = "notification-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "notification-api"
      image     = var.notification_image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [{
        containerPort = 3000
        hostPort      = 3000
        protocol      = "tcp"
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_notification_api.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

# ECS Task Definition for Email Sender
resource "aws_ecs_task_definition" "email_task" {
  family                   = "email-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "email-sender"
      image     = var.email_image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [{
        containerPort = 3001
        hostPort      = 3001
        protocol      = "tcp"
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_email_sender.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

# ECS Service for Notification API
resource "aws_ecs_service" "notification_service" {
  name            = "notification-service"
  cluster         = aws_ecs_cluster.ecs_cluster01.id
  task_definition = aws_ecs_task_definition.notification_task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "notification-api"
    container_port   = 3000
  }

  depends_on = [aws_cloudwatch_log_group.ecs_notification_api]
}

# ECS Service for Email Sender
resource "aws_ecs_service" "email_service" {
  name            = "email-service"
  cluster         = aws_ecs_cluster.ecs_cluster01.id
  task_definition = aws_ecs_task_definition.email_task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
    assign_public_ip = false
  }

  depends_on = [aws_cloudwatch_log_group.ecs_email_sender]
}

output "cluster_name" {
  value = aws_ecs_cluster.ecs_cluster01.name
}

output "notification_service_name" {
  value = aws_ecs_service.notification_service.name
}
output "notification_api_tg_arn" {
  value = var.target_group_arn

}