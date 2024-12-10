resource "aws_ecs_cluster" "main" {
  name = "main-cluster"
}

resource "aws_ecs_service" "notification_api" {
  name            = "notification-api"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.notification_api.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}

resource "aws_ecs_service" "email_sender" {
  name            = "email-sender"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.email_sender.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}
