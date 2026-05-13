variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ALB will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "alb_conf" {
  description = "ALB configuration block"
  type = object({
    enable_deletion_protection = bool
    additional_tags            = map(string)
    target_group = object({
      port              = number
      protocol          = string
      health_check_path = string
    })
  })
}
