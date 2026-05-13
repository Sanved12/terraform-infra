//====================================================================================\\
//                                    Variables                                       \\
//====================================================================================\\
#========== Common Variables ==========#

variable "region" {
  description = "AWS region to deploy the resources in"
}

variable "environment" {
  description = "Environment tag to be used. Ex: dev/qa/production"
}

#========== VPC ==========#

variable "vpc_conf" {
  description = "All network related configurations such as: VPC CIDRs, Subnets, Internet Gateway, NAT configurations"
}