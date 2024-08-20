resource "aws_ecs_cluster" "cluster" {
  name = "notification_cluster"
}

resource "aws_ecs_task_definition" "notification_task" {
  family                   = "notification_task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([{
    name      = "notification_api"
    image     = "notification_api:latest"
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
  }])
}

resource "aws_ecs_task_definition" "email_sender_task" {
  family                   = "email_sender_task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([{
    name      = "email_sender"
    image     = "email_sender:latest"
    essential = true
  }])
}
