resource "aws_ecs_task_definition" "notification_api" {
  family                   = "notification-api"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = jsonencode([{
    name      = "notification-api"
    image     = var.notification_api_image_uri
    memory    = 512
    cpu       = 256
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/notification-api"
        "awslogs-region"        = "us-west-2"
        "awslogs-stream-prefix" = "ecs"
      }
    }
    healthCheck = {
      command     = ["CMD-SHELL", "curl -f http://localhost:80/health || exit 1"]
      interval    = 30
      timeout     = 5
      retries     = 3
      startPeriod = 60
    }
  }])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
}

resource "aws_ecs_task_definition" "email_sender" {
  family                   = "email-sender"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = jsonencode([{
    name      = "email-sender"
    image     = var.email_sender_image_uri
    memory    = 512
    cpu       = 256
    essential = true
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/email-sender"
        "awslogs-region"        = "us-west-2"
        "awslogs-stream-prefix" = "ecs"
      }
    }
    healthCheck = {
      command     = ["CMD-SHELL", "curl -f http://localhost:80/health || exit 1"]
      interval    = 30
      timeout     = 5
      retries     = 3
      startPeriod = 60
    }
  }])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
}

resource "aws_ecs_service" "notification_api" {
  name            = "notification-api-service"
  cluster         = aws_ecs_cluster.notification_cluster.id
  task_definition = aws_ecs_task_definition.notification_api.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public.*.id
    security_groups  = [aws_security_group.ecs_service.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.notification_api.arn
    container_name   = "notification-api"
    container_port   = 80
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent = 200

  health_check_grace_period_seconds = 60
}

resource "aws_ecs_service" "email_sender" {
  name            = "email-sender-service"
  cluster         = aws_ecs_cluster.notification_cluster.id
  task_definition = aws_ecs_task_definition.email_sender.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public.*.id
    security_groups  = [aws_security_group.ecs_service.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.email_sender.arn
    container_name   = "email-sender"
    container_port   = 80
  }

  deployment_controller {
    type = "ECS"
  }
}  

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
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