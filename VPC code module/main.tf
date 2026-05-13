//====================================================================================\\
//                                   Terraform Provider                               \\
//====================================================================================\\

terraform {
  required_version = ">= 0.15.0"
  required_providers {
    aws = {
      version = ">= 4.33.0"
    }
  }
}

//====================================================================================\\
//                                   Local Variables                                  \\
//====================================================================================\\

locals {
  vpc_id              = module.vpc.vpc_id
  public_subnets      = module.vpc.public_subnets_ids
  private_app_subnets = module.vpc.private_app_subnets_ids
  private_db_subnets  = module.vpc.private_db_subnets_ids
}

//====================================================================================\\
//                                   AWS Provider                                     \\
//====================================================================================\\

provider "aws" {
  region  = var.region
  profile = "dataviv"
}

//====================================================================================\\
//                                   VPC and Related Resources                        \\
//====================================================================================\\

module "vpc" {
  source      = "./modules/vpc"
  region      = var.region
  environment = var.environment
  vpc_conf    = var.vpc_conf
}