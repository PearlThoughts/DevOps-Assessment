resource "aws_lb_target_group" "new_notification_api_tg" {
  name        = var.target_group_name
  port        = var.port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"  # Ensure this is set to "ip"

  health_check {
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    matcher             = var.health_check_matcher
  }

  tags = {
    Name = "new-notification-api-tg"
  }
}

output "target_group_arn" {
  value = aws_lb_target_group.new_notification_api_tg.arn
}
