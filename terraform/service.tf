resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_ecs_task_definition" "notification_api_task" {
  family                   = "notification_api_task"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "notification-api"
      image     = "339713152546.dkr.ecr.region.amazonaws.com/notification-api:latest"
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
          "awslogs-group"         = "/ecs/notification_api_logs"
          "awslogs-region"        = "your-region"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "email_sender_task" {
  family     execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "email-sender"
      image     = "339713152546.dkr.ecr.region.amazonaws.com/email-sender:latest"
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
          "awslogs-group"         = "/ecs/email_sender_logs"
          "awslogs-region"        = "your-region"
          "awslogs-stream-prefix" = "ecs"
        }
      }
   ])
}   }

