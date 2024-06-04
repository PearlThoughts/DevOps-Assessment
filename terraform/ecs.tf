# ecs.tf
resource "aws_ecs_cluster" "cluster" {
  name = "notification-cluster"
}

resource "aws_ecs_task_definition" "notification_task" {
  family                = "notification-task"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = 256
  memory                = 512

  container_definitions = jsonencode([{
    name = "notification-api"
    image = "rishi0910/notification-api:latest"
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
  }])
}

resource "aws_ecs_task_definition" "email_sender_task" {
  family                = "email-sender-task"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = 256
  memory                = 512

  container_definitions = jsonencode([{
    name = "email-sender"
    image = "rishi0910/email-sender:latest"
    essential = true
  }])
}

resource "aws_ecs_service" "notification_service" {
  name            = "notification-api-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.notification_task.arn
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.subnet.id]
    security_groups  = [aws_security_group.sg.id]
  }

  launch_type = "FARGATE"
}

resource "aws_ecs_service" "email_sender_service" {
  name            = "email-sender-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.email_sender_task.arn
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.subnet.id]
    security_groups  = [aws_security_group.sg.id]
  }

  launch_type = "FARGATE"
}
