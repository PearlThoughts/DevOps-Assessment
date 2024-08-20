resource "aws_launch_configuration" "notification_api_lc" {
  name          = "notification_api_lc"
  image_id       = "ami-090abff6ae1141d7d"  # Ensure this is the correct AMI ID for your region
  instance_type  = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "email_sender_lc" {
  name          = "email_sender_lc"
  image_id       = "ami-090abff6ae1141d7d"  # Ensure this is the correct AMI ID for your region
  instance_type  = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}
