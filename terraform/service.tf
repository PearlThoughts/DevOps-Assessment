resource "aws_ecs_task_definition" "ecs_app_def" {
  family                   = var.aws_ecs_task_def_fam
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory

  container_definitions = jsonencode([
    {
      name   = var.aws_ecr_repository
      image  = "${var.aws_account_id}.dkr.ecr.ap-east-1.amazonaws.com/demo_ecs_app:latest"
      cpu    = var.fargate_cpu
      memory = var.fargate_memory
      portMappings = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "notification_service" {
  name            = var.aws_ecs_service_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.ecs_app_def.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_task.id]
    subnets          = [aws_subnet.subnet.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_port   = var.app_port
    container_name   = var.aws_ecr_repository
  }

  depends_on = [
    aws_alb.main,
    aws_alb_target_group.app,
    aws_ecs_task_definition.ecs_app_def,
    aws_iam_role.ecs_task_execution_role,
    aws_iam_role_policy_attachment.ecs_task_execution_role
  ]
}
