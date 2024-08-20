resource "aws_lb" "ecs_lb" {
  name               = "ecs-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = {
    Name = "ecs-lb"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn  # Reference to the target group output
  }
}
output "elb_dns_name" {
  value = aws_lb.ecs_lb.dns_name
}
