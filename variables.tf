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

#========== S3 Backend ==========#

variable "s3_conf" {
  description = "S3 state backend bucket and DynamoDB lock table configuration"
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

variable "github_owner" {
  description = "GitHub repository owner (org or username)"
}

variable "github_repo" {
  description = "GitHub repository name"
}

variable "github_branch" {
  description = "Branch to trigger the pipeline"
  default     = "main"
}

variable "pipeline_bucket" {
  description = "S3 bucket name for CodePipeline artifacts (must be globally unique)"
}

variable "codestar_connection_arn" {
  description = "CodeStar connection ARN for GitHub (must be pre-created and activated)"
}
