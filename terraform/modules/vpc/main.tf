# Fetch available availability zones in the region
data "aws_availability_zones" "available" {}

# Create the VPC
resource "aws_vpc" "app_vpc1" {
  cidr_block = var.cidr_block

  tags = {
    Name = "custom-vpc1"
  }
}

# Create public subnets within the VPC
resource "aws_subnet" "public_subnet" {
  count             = 2
  vpc_id            = aws_vpc.app_vpc1.id
  cidr_block        = cidrsubnet(aws_vpc.app_vpc1.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}
# Create private subnets within the VPC
resource "aws_subnet" "private_subnet" {
  count             = 2
  vpc_id            = aws_vpc.app_vpc1.id
  cidr_block        = cidrsubnet(aws_vpc.app_vpc1.cidr_block, 8, count.index + 2)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}


# Create an internet gateway for public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc1.id

  tags = {
    Name = "custom-vpc1-igw"
  }
}
# Create a NAT gateway in the first public subnet
resource "aws_eip" "nat_eip" {
  domain = "vpc"

}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "custom-vpc1-nat-gw"
  }
}

# Create route tables for public subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_assoc" {
  count          = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Create route tables for private subnets
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.app_vpc1.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_subnet_assoc" {
  count          = 2
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}



# Create a security group for the VPC
resource "aws_security_group" "default" {
  vpc_id = aws_vpc.app_vpc1.id

  # Optional: Add inbound rules if needed
  ingress {
    from_port   = 80      # Example: Allow HTTP traffic
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443     # Example: Allow HTTPS traffic
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
    Name = "default-sg"
  }
}

output "vpc_id" {
  value = aws_vpc.app_vpc1.id
}

output "public_subnets" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnets" {
  value = aws_subnet.private_subnet[*].id
}

output "security_group_id" {
  value = aws_security_group.default.id
}
