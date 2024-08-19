# Define the ECS Task Definition for Notification API
resource "aws_ecs_task_definition" "notification_api" {
  family                   = "notification-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "2048"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "notification-api"
    image     = "${aws_ecr_repository.notification_api.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
  }])
}

# Define the ECS Service for Notification API
resource "aws_ecs_service" "notification_api_service" {
  name            = "notification-api-service"
  cluster         = aws_ecs_cluster.notification_cluster.id
  task_definition = aws_ecs_task_definition.notification_api.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-12345678", "subnet-87654321"]  # Replace with actual subnet IDs
    security_groups = ["sg-12345678"]  # Replace with actual security group ID
  }
}
