resource "aws_lb" "main" {
  name               = "notification-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = ["subnet-03b108e1dafc6f9e5","subnet-0f47b25e174d49d09"]  # Replace with your subnet IDs

  enable_deletion_protection = false
}
resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = "vpc-0fb809d348139ac47"
  


  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App traffic from Load Balancer"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_task_sg" {
  name        = "ecs_task_sg"
  description = "Allow inbound traffic from Load Balancer"
  vpc_id      = "vpc-0fb809d348139ac47"

  ingress {
    description = "Allow traffic from load balancer"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


output "load_balancer_dns_name" {
  value = aws_lb.main.dns_name
}
output "cluster_id" {
  value = aws_ecs_cluster.mycluster.id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.notification_service.repository_url
}