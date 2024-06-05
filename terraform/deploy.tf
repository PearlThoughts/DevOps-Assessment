provider "aws" {
  region = "YOUR_REGION"
}

resource "aws_ecr_repository" "notification_api" {
  name = "notification-api"
}

resource "aws_ecr_repository" "email_sender" {
  name = "email-sender"
}

resource "null_resource" "push_images_to_ecr" {
  provisioner "local-exec" {
    command = "./script.sh"
  }

  depends_on = [aws_ecr_repository.notification_api, aws_ecr_repository.email_sender]
}

resource "aws_ecs_cluster" "main" {
  name = "notification-cluster"
}

resource "aws_ecs_task_definition" "notification_api" {
  family                   = "notification-api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

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
  family                   = "email-sender-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

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

resource "aws_application_autoscaling_target" "notification_api" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.notification_api.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_application_autoscaling_policy" "notification_api" {
  name                   = "notification-api-scaling-policy"
  policy_type            = "TargetTrackingScaling"
  resource_id            = aws_application_autoscaling_target.notification_api.resource_id
  scalable_dimension     = aws_application_autoscaling_target.notification_api.scalable_dimension
  service_namespace      = aws_application_autoscaling_target.notification_api.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value                          = 70.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown                     = 300
    scale_out_cooldown                    = 300
  }
}

resource "aws_application_autoscaling_target" "email_sender" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.email_sender.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_application_autoscaling_policy" "email_sender" {
  name                   = "email-sender-scaling-policy"
  policy_type            = "TargetTrackingScaling"
  resource_id            = aws_application_autoscaling_target.email_sender.resource_id
  scalable_dimension     = aws_application_autoscaling_target.email_sender.scalable_dimension
  service_namespace      = aws_application_autoscaling_target.email_sender.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value                          = 70.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown                     = 300
    scale_out_cooldown                    = 300
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

variable "aws_region" {
  description = "The AWS region to create resources in"
  default     = "YOUR_REGION"
}

variable "aws_account_id" {
  description = "The AWS account ID"
}
