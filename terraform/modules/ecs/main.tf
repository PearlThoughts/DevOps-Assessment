resource "aws_ecs_task_definition" "notification" {
  # ... existing configuration
  container_definitions = jsonencode([
    {
      name      = "notification"
      image     = var.notification_image_url
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:3000/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    }
  ])
}

resource "aws_ecs_task_definition" "email_sender" {
  # ... existing configuration
  container_definitions = jsonencode([
    {
      name      = "email-sender"
      image     = var.email_sender_image_url
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:5000/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    }
  ])
}

