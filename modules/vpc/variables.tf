variable "region" {
  description = "AWS region to deploy the resources in"
}

variable "environment" {
  description = "Environment name (e.g. poc, dev, staging, prod)"
}

variable "vpc_conf" {
  description = "Network resources related configuration for the creation of VPC, Subnets, Internet Gateway, NAT gateway, Route table etc"
}
