# Bastion Security Group
resource "aws_security_group" "bastion_sg" {
  vpc_id      = aws_vpc.prod_vpc.id
  description = "Allow SSH from the world"

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "Project-Bastion-SG"
  }
}

# ALB Security Group
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.prod_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "Project-ALB-SG"
  }
}

# Web Server Security Group
resource "aws_security_group" "web_sg" {
  vpc_id      = aws_vpc.prod_vpc.id
  description = "Allow HTTP and SSH"

  # Allow HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Project-Web-SG"
  }
}


# Retrieve the network interface for the Cloud9 instance
data "aws_network_interface" "cloud9_eni" {
  filter {
    name   = "description"
    values = ["*${aws_cloud9_environment_ec2.cloud9_env.name}*"]
  }
}

# Use the security group of the Cloud9 environment
resource "aws_security_group_rule" "allow_ssh_from_cloud9" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_sg.id 
  source_security_group_id = [for sg in data.aws_network_interface.cloud9_eni.security_groups : sg][0]
}

# Security Group for Private Instances (Restricting access only from Bastion Host)
resource "aws_security_group" "private_instance_sg" {
  vpc_id      = aws_vpc.prod_vpc.id
  description = "Allow SSH only from Bastion Host"

  ingress {
    description     = "Allow SSH from Bastion Host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Project-Private-Instance-SG"
  }
}
