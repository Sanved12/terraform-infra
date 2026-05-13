variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EC2 instances will be deployed"
  type        = string
}

variable "private_app_subnet_ids" {
  description = "List of private application subnet IDs"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security Group ID of the ALB (to allow traffic from ALB to EC2)"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB Target Group to attach EC2 instances"
  type        = string
}

variable "ec2_conf" {
  description = "EC2 configuration block"
  type = object({
    ami_id          = string
    instance_type   = string
    instance_count  = number
    app_port        = number
    public_key      = string
    additional_tags = map(string)
    root_volume = object({
      type    = string
      size_gb = number
    })
  })
}
