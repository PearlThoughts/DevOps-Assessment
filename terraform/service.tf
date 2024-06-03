resource "aws_ecs_service" "notification_api" {
  name            = "notification-api"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.notification_api.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [aws_subnet.main.id]
    security_groups  = [aws_security_group.main.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.notification_api.arn
    container_name   = "notification-api"
    container_port   = 3000
  }
  service_registries {
    registry_arn = aws_service_discovery_service.notification_api.arn
  }
}

resource "aws_ecs_service" "email_sender" {
  name            = "email-sender"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.email_sender.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [aws_subnet.main.id]
    security_groups  = [aws_security_group.main.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.email_sender.arn
    container_name   = "email-sender"
    container_port   = 3000
  }
  service_registries {
    registry_arn = aws_service_discovery_service.email_sender.arn
  }
}
