//=======================================================================================================\\
//                                      Global Variables                                                 \\
//=======================================================================================================\\

variable "region" {
  description = "AWS region where the resources will be created"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g. poc, dev, staging, prod)"
  type        = string
}

//=======================================================================================================\\
//                                       S3 Variables                                                    \\
//=======================================================================================================\\

variable "s3_conf" {
  description = "S3 state backend bucket configuration"
  type = object({
    bucket_name    = string
    dynamodb_table = string
  })
}

//=======================================================================================================\\
//                                       VPC Variables                                                   \\
//=======================================================================================================\\

variable "vpc_conf" {
  description = "Complete VPC configuration block"
  type = object({
    vpc = object({
      cidr_vpc        = string
      additional_tags = map(string)
    })
    nat_gateway = object({
      additional_tags = map(string)
    })
    subnets = object({
      public_subnets = object({
        name            = string
        cidr            = list(string)
        additional_tags = map(string)
      })
      private_app_subnets = object({
        name            = string
        cidr            = list(string)
        additional_tags = map(string)
      })
      private_db_subnets = object({
        name            = string
        cidr            = list(string)
        additional_tags = map(string)
      })
    })
  })
}

//=======================================================================================================\\
//                                       ALB Variables                                                   \\
//=======================================================================================================\\

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

//=======================================================================================================\\
//                                       EC2 Variables                                                   \\
//=======================================================================================================\\

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

//=======================================================================================================\\
//                                     CI/CD Variables                                                   \\
//=======================================================================================================\\

variable "github_owner" {
  description = "GitHub repository owner (org or username)"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "github_branch" {
  description = "Branch to trigger the pipeline"
  type        = string
  default     = "main"
}

variable "pipeline_bucket" {
  description = "S3 bucket name for CodePipeline artifacts (must be globally unique)"
  type        = string
}

variable "codestar_connection_arn" {
  description = "CodeStar connection ARN for GitHub (must be pre-created and activated)"
  type        = string
}
