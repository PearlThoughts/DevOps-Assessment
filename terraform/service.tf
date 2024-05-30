resource "aws_ecs_task_definition" "notification_task" {
  family                   = "notification-service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name = "notification-service"
    image = "${aws_ecr_repository.notification_service.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort = 3000
    }]
    environment = [{
      name = "NODE_ENV"
      value = "production"
    }]
    secrets = [{
      name = "DB_PASSWORD"
      valueFrom = aws_secretsmanager_secret.db_password.arn
    }]
  }])
}

resource "aws_ecs_service" "notification_service" {
  name            = "notification-service"
  cluster         = aws_ecs_cluster.notification_cluster.id
  task_definition = aws_ecs_task_definition.notification_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = ["subnet-12345678"]  # Replace with your subnet IDs
    security_groups  = ["sg-12345678"]      # Replace with your security group IDs
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.notification_service_target_group.arn
    container_name   = "notification-service"
    container_port   = 3000
  }
}
