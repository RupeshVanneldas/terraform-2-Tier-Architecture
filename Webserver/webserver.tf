data "terraform_remote_state" "networks" {
  backend = "s3"
  config = {
    bucket = "aws-bucket-project1"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
  }
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# EC2 Instance: Webserver 1 (Public Subnet 1)
resource "aws_instance" "webserver_1" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.networks.outputs.public_subnet_1
  security_groups = [data.terraform_remote_state.networks.outputs.web_sg]
  key_name       = aws_key_pair.project_key.key_name
  tags = {
    Name = "Project-Webserver1",
    Access = "Public"
  }
}

# EC2 Instance: Webserver 2 (Bastion Host in Public Subnet 2)
resource "aws_instance" "webserver_2" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.networks.outputs.public_subnet_2
  security_groups = [data.terraform_remote_state.networks.outputs.bastion_sg, data.terraform_remote_state.networks.outputs.web_sg]
  key_name       = aws_key_pair.project_key.key_name
  tags = {
    Name = "Project-BastionHost",
    Access = "Public"
  }
}

# EC2 Instance: Webserver 3 (Public Subnet 3)
resource "aws_instance" "webserver_3" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.networks.outputs.public_subnet_3
  security_groups = [data.terraform_remote_state.networks.outputs.web_sg]
  key_name       = aws_key_pair.project_key.key_name
  tags = {
    Name = "Project-Webserver3",
    Access = "Public"
  }
}

# EC2 Instance: Webserver 4 (Public Subnet 4)
resource "aws_instance" "webserver_4" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.networks.outputs.public_subnet_4
  security_groups = [data.terraform_remote_state.networks.outputs.web_sg]
  key_name       = aws_key_pair.project_key.key_name
  tags = {
    Name = "Project-Webserver4",
    Access = "Public"
  }
}

# EC2 Instance: Webserver 5 (Private Subnet 1 with NAT Gateway)
resource "aws_instance" "webserver_5" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.networks.outputs.private_subnet_1
  security_groups = [data.terraform_remote_state.networks.outputs.private_instance_sg]
  associate_public_ip_address = false
  key_name       = aws_key_pair.project_key.key_name
  tags = {
    Name = "Project-Webserver5",
    Access = "Private"
  }
}

# EC2 Instance: VM 6 (Private Subnet 2)
resource "aws_instance" "vm_6" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.networks.outputs.private_subnet_2
  security_groups = [data.terraform_remote_state.networks.outputs.private_instance_sg]
  associate_public_ip_address = false
  key_name       = aws_key_pair.project_key.key_name
  tags = {
    Name = "Project-VM6",
    Access = "Private"
  }
}
