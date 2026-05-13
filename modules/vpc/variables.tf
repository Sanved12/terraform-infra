variable "region" {
  description = "AWS region to deploy the resources in"
}

variable "environment" {
  description = "Environment name (e.g. poc, dev, staging, prod)"
  type        = string
}

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
