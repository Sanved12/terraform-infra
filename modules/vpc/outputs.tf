//=======================================================================================================\\
//                                           VPC Outputs                                                 \\
//=======================================================================================================\\

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "private_app_subnet_ids" {
  description = "List of IDs of private application subnets"
  value       = aws_subnet.private_app_subnets[*].id
}

output "private_db_subnet_ids" {
  description = "List of IDs of private DB subnets"
  value       = aws_subnet.private_db_subnets[*].id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.ngwA.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.rtb_public.id
}

output "private_app_route_table_id" {
  description = "The ID of the private application route table"
  value       = aws_route_table.rtb_private_app.id
}

output "private_db_route_table_id" {
  description = "The ID of the private DB route table"
  value       = aws_route_table.rtb_private_db.id
}
