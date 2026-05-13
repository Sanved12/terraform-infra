//=======================================================================================================\\
//                                           EC2 Outputs                                                 \\
//=======================================================================================================\\

output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = aws_instance.app_servers[*].id
}

output "instance_private_ips" {
  description = "List of private IP addresses of EC2 instances"
  value       = aws_instance.app_servers[*].private_ip
}

output "ec2_security_group_id" {
  description = "Security Group ID attached to EC2 instances"
  value       = aws_security_group.ec2_sg.id
}

output "key_pair_name" {
  description = "EC2 Key Pair name (if created)"
  value       = length(aws_key_pair.ec2_key) > 0 ? aws_key_pair.ec2_key[0].key_name : null
}
