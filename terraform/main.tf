resource "aws_vpc" "myvpc" {
   cidr_block = "10.0.0.0/16"
   instance_tenancy = "default"
   enable_dns_hostnames = "true"
   tags = {
     Name = "my-vpc"
   }
}

resource "aws_subnet" "mysubnet" {
   vpc_id = aws_vpc.myvpc.id
   cidr_block = "10.0.0.0/16"
   availability_zone = "ap-south-1a"
   tags = {
     Name = "subnet-1"
   }
}
    
resource "aws_security_group" "app_sg" {
  vpc_id = aws_vpc.myvpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
     Name = "sg-group1"
   }
}   

resource "aws_ecs_task_definition" "notificationapp" {
  family                   = "notificationtask"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name      = "notification-app"
    image     = "public.ecr.aws/s4p0i4x0/demo:latest"
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
  }])
}
