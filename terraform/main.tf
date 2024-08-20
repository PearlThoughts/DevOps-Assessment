# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-ecs-cluster"
}

# IAM Roles for ECS tasks
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.environment}-ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.environment}-ecs-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerServiceFullAccess"
  ]
}

# Secrets for sensitive data
resource "aws_secretsmanager_secret" "db_credentials" {
  name = "${var.environment}-db-credentials"
  description = "Database credentials"
}

# SQS Queue
resource "aws_sqs_queue" "notification_queue" {
  name = "${var.environment}-notification-queue"
}

# ECS Task Definition for Notification API
resource "aws_ecs_task_definition" "notification_api" {
  family                   = "${var.environment}-notification-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "notification-api"
      image     = var.notification_api_image
      essential = true
      portMappings = [{
        containerPort = 80
        hostPort      = 80
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.environment}/notification-api"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        {
          name  = "QUEUE_URL"
          value = aws_sqs_queue.notification_queue.id
        }
      ]
    }
  ])
}

# ECS Service for Notification API
resource "aws_ecs_service" "notification_api" {
  name            = "${var.environment}-notification-api"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.notification_api.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = aws_subnet.public_subnet.*.id
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.notification_api.arn
    container_name   = "notification-api"
    container_port   = 80
  }

  service_registries {
    registry_arn = aws_service_discovery_service.notification_api.arn
  }
}

# Autoscaling policy
resource "aws_appautoscaling_target" "notification_api" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.notification_api.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 1
  max_capacity       = 10
}

resource "aws_appautoscaling_policy" "cpu_policy" {
  name               = "cpu-scaling"
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.notification_api.resource_id
  scalable_dimension = "ecs:service:DesiredCount"

  policy_type = "TargetTrackingScaling"
  target_tracking_scaling_policy_configuration {
    target_value = var.cpu_threshold
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
