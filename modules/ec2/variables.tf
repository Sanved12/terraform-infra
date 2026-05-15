variable "environment" {
  description = "Environment name (e.g. poc, dev, staging, prod)"
}

variable "vpc_id" {
  description = "VPC ID where EC2 instances will be deployed"
}

variable "private_app_subnet_ids" {
  description = "List of private application subnet IDs"
}

variable "alb_security_group_id" {
  description = "Security Group ID of the ALB (to allow traffic from ALB to EC2)"
}

variable "target_group_arn" {
  description = "ARN of the ALB Target Group to attach EC2 instances"
}

variable "ec2_conf" {
  description = "EC2 related configuration for the creation of EC2 instances, Security Group, Key Pair, Root Volume etc"
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  default     = {}
}
