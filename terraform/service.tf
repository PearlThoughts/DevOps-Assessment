resource "aws_ecs_task_definition" "notification_api" {
  family                   = "notification-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "notification-api"
      image     = "${aws_ecr_repository.notification_api.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/notification-api"
          awslogs-region        = "us-west-2"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "notification_api" {
  name            = "notification-api-service"
  cluster         = aws_ecs_cluster.notification-cluster.id
  task_definition = aws_ecs_task_definition.notification_api.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }
}
