//====================================================================================\\
//                                    Variables                                       \\
//====================================================================================\\

#========== Common Variables ==========#

variable "region" {
  description = "AWS region where the resources will be created"
}

variable "environment" {
  description = "Environment name (e.g. poc, dev, staging, prod)"
}

#========== Common Tags ==========#

variable "common_tags" {
  description = "Common tags applied to all resources"
  default     = {}
}

#========== S3 Backend ==========#

variable "s3_conf" {
  description = "S3 state backend bucket configuration"
}

#========== VPC ==========#

variable "vpc_conf" {
  description = "All network related configurations such as: VPC CIDRs, Subnets, Internet Gateway, NAT configurations"
}

#========== ALB ==========#

variable "alb_conf" {
  description = "All ALB related configurations such as: target group, listener, health check, deletion protection"
}

#========== EC2 ==========#

variable "ec2_conf" {
  description = "All EC2 related configurations such as: AMI, instance type, count, app port, SSH key, root volume"
}

#========== CI/CD ==========#

variable "cicd_conf" {
  description = "All CI/CD related configurations such as: GitHub source, pipeline artifact bucket, CodeStar connection, Terraform version"
}
