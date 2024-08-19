resource "aws_ecs_task_definition" "devops_assessment_etd" {
  family                   = "devopsAssessmentTd"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::279660579228:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([{
    name      = "devops-assessment"
    image     = "${aws_ecr_repository.devops_assessment_repository.repository_url}:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
  }])
}

resource "aws_ecs_service" "devops_assessment_ecs_service" {
   task_definition = aws_ecs_task_definition.devops_assessment_etd.id
   cluster = aws_ecs_cluster.devops_assessment_cluster.id
   launch_type = "FARGATE"
   name = "devopsAssessmentEcsService"
   desired_count   = 1
   network_configuration {
    subnets         = aws_subnet.devops_assessment_subnet[*].id
    security_groups = [
        aws_security_group.sg.id
    ]
    assign_public_ip = true
   }
}