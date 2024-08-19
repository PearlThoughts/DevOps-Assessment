resource "aws_vpc" "devops_assessment_vpc" {
   cidr_block = "10.1.0.0/16"
   instance_tenancy = "default"
   enable_dns_hostnames = "true"
   tags = {
     Name = "devopsAssessmentVpc"
   }
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.devops_assessment_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
     Name = "sg"
   }
}   

resource "aws_subnet" "devops_assessment_subnet" {
   vpc_id = aws_vpc.devops_assessment_vpc.id
   cidr_block = "10.1.0.0/16"
   availability_zone = "ap-south-1a"
   tags = {
     Name = "subnet-ap-south-1a"
   }
}

resource "aws_internet_gateway" "devops_assessment_igw" {
  vpc_id = aws_vpc.devops_assessment_vpc.id

  tags = {
    Name = "devops_assessment_igw"
  }
}

resource "aws_route_table" "devops_assessment_rt" {
  vpc_id = aws_vpc.devops_assessment_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_assessment_igw.id
  }

  tags = {
    Name = "igw-route"
  }
}

resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.devops_assessment_subnet.id
  route_table_id = aws_route_table.devops_assessment_rt.id
}