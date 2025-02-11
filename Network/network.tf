# VPC
resource "aws_vpc" "prod_vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Project-Prod-VPC"
  }
}

# Public Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.prod_vpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Project-Public-Subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.prod_vpc.id
  cidr_block              = "10.1.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Project-Public-Subnet-2"
  }
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id                  = aws_vpc.prod_vpc.id
  cidr_block              = "10.1.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "Project-Public-Subnet-3"
  }
}

resource "aws_subnet" "public_subnet_4" {
  vpc_id                  = aws_vpc.prod_vpc.id
  cidr_block              = "10.1.4.0/24"
  availability_zone       = "us-east-1d"
  map_public_ip_on_launch = true

  tags = {
    Name = "Project-Public-Subnet-4"
  }
}

# Private Subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.1.5.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Project-Private-Subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.1.6.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Project-Private-Subnet-2"
  }
}

# Cloud9 Environment
resource "aws_cloud9_environment_ec2" "cloud9_env" {

  name                        = "Project-Cloud9-Environment"
  instance_type               = "t3.medium" # Instance type for Cloud9
  subnet_id                   = aws_subnet.public_subnet_1.id
  automatic_stop_time_minutes = 120
  image_id                    = "amazonlinux-2023-x86_64"

  tags = {
    Project     = "Cloud9-Environment"
    Environment = "Development"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = "Project-Internet-Gateway"
  }
}

# NAT Gateway
resource "aws_eip" "eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id         = aws_subnet.public_subnet_1.id
  connectivity_type = "public"
  allocation_id     = aws_eip.eip.id
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "Project-Public-Route-Table"
  }
}

resource "aws_route_table_association" "public_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_association_3" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_association_4" {
  subnet_id      = aws_subnet.public_subnet_4.id
  route_table_id = aws_route_table.public_route_table.id
}

# Private Route Table (with NAT Gateway)
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "Project-Private-Route-Table"
  }
}

resource "aws_route_table_association" "private_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}
