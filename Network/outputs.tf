# Outputs for VPC and Subnets
output "vpc_id" {
  value       = aws_vpc.prod_vpc.id
  description = "The ID of the production VPC."
}

output "public_subnet_1" {
  value       = aws_subnet.public_subnet_1.id
  description = "The IDs of the public subnet 1"
}

output "public_subnet_2" {
  value       = aws_subnet.public_subnet_2.id
  description = "The IDs of the public subnet 2"
}

output "public_subnet_3" {
  value       = aws_subnet.public_subnet_3.id
  description = "The IDs of the public subnet 3"
}

output "public_subnet_4" {
  value       = aws_subnet.public_subnet_4.id
  description = "The IDs of the public subnet 4"
}

output "private_subnet_1" {
  value       = aws_subnet.private_subnet_1.id
  description = "The IDs of the private subnet 1"
}

output "private_subnet_2" {
  value       = aws_subnet.private_subnet_2.id
  description = "The IDs of the private subnet 2"
}

# Outputs for Internet Gateway
output "internet_gateway_id" {
  value       = aws_internet_gateway.internet_gateway.id
  description = "The ID of the Internet Gateway."
}

# Outputs for NAT Gateway
output "nat_gateway_id" {
  value       = aws_nat_gateway.nat_gateway.id
  description = "The ID of the NAT Gateway."
}

output "nat_gateway_eip" {
  value       = aws_eip.eip.public_ip
  description = "The public IP address of the NAT Gateway."
}

# Outputs for Route Tables
output "public_route_table_id" {
  value       = aws_route_table.public_route_table.id
  description = "The ID of the public route table."
}

output "private_route_table_id" {
  value       = aws_route_table.private_route_table.id
  description = "The ID of the private route table."
}

# Output for Web Server Security Group 
output "web_sg" {
  value       = aws_security_group.web_sg.id
  description = "The ID of the Web Server security group."
}

output "alb_sg" {
  value = aws_security_group.alb_sg.id
}

output "bastion_sg" {
  value = aws_security_group.bastion_sg.id
}

# Output for Private Instance Security Group

output "private_instance_sg" {
  value       = aws_security_group.private_instance_sg.id
  description = "The ID of the Private Instance security group."

}
