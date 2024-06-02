resource "aws_ecs_cluster" "notification_cluster" {
  name = "notification_cluster"
}

resource "aws_ecs_task_definition" "notification_task" {
  family                   = "notification-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = jsonencode([
    {
      name      = "notification-container"
      image     = "992382552335.dkr.ecr.ap-south-1.amazonaws.com/notification-service:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/notification-service"
        awslogs-region        = "ap-south-1"
        awslogs-stream-prefix = "ecs"
      }
    }
    healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:3000/api || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    }
  ])
}

resource "aws_lb_target_group" "notification_tg" {
  name     = "notification-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "vpc-0fb809d348139ac47"
  target_type = "ip"

  health_check {
    path                = "/api"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

resource "aws_lb_listener" "notification_lb_listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.notification_tg.arn
  }

  dynamic "default_action" {
    for_each = var.forwarding_rules
    content {
      type = default_action.value.type

      redirect {
        port        = default_action.value.redirect.port
        protocol    = default_action.value.redirect.protocol
        host        = default_action.value.redirect.host
        path        = default_action.value.redirect.path
        query       = default_action.value.redirect.query
        status_code = default_action.value.redirect.status_code
      }
    }
  }
}

variable "forwarding_rules" {
  description = "Forwarding rules for ALB listener"
  type = list(object({
    type     = string
    redirect = object({
      port        = string
      protocol    = string
      host        = string
      path        = string
      query       = string
      status_code = string
    })
  }))
  default = [
    {
      type = "redirect"
      redirect = {
        port        = "80"
        protocol    = "HTTP"
        host        = var.load_balancer_dns_name
        path        = "/api"
        query       = "#{query}"
        status_code = "HTTP_301"
      }
    }
  ]
}


resource "aws_ecs_service" "notification_service" {
  name            = "notification-service"
  cluster         = aws_ecs_cluster.notification_cluster.id
  task_definition = aws_ecs_task_definition.notification_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-03b108e1dafc6f9e5","subnet-0f47b25e174d49d09"]  
    security_groups  = ["sg-01f2e8a08f271674d"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.notification_tg.arn
    container_name   = "notification-container"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.notification_lb_listener]
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]
}