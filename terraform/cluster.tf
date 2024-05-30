resource "aws_ecs_cluster" "cluster" {
  name = "notification-cluster"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "notification-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "notification"
      image     = "${aws_ecr_repository.notification.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}
