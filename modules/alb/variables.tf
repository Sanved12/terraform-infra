//=======================================================================================================\\
//                                         ALB Variables                                                 \\
//=======================================================================================================\\

variable "environment" {
  description = "Environment name (e.g. poc, dev, staging, prod)"
}

variable "vpc_id" {
  description = "VPC ID where ALB will be deployed"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
}

variable "alb_conf" {
  description = "ALB related configuration for the creation of ALB, Target Group, Listener, Security Group etc"
}
