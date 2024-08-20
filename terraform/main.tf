resource "aws_autoscaling_group" "notification_api_asg" {
  launch_configuration = aws_launch_configuration.notification_api_lc.id
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2
  vpc_zone_identifier  = ["subnet-0368b5fa780d3656a"]
  availability_zones   = ["eu-north-1a", "eu-north-1b"]

  tag {
    key                 = "Name"
    value               = "notification-api-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "email_sender_asg" {
  launch_configuration = aws_launch_configuration.email_sender_lc.id  min_size             = 1
  max_size             = 3
  desired_capacity     = 2
  vpc_zone_identifier  = ["subnet-0368b5fa780d3656a"]
  availability_zones   = ["eu-north-1b", "eu-north-1b"]

  tag {
    key                 = "Name"
    value               = "email-sender-instance"
    propagate_at_launch = true
  }
}
