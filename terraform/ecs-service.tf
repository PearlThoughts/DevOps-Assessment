resource "aws_ecs_service" "nx_service" {
  name            = "nx-app-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.nx_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = aws_subnet.main[*].id
    security_groups = [aws_security_group.web_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "nx-app-container"
    container_port   = 3000
  }
}
