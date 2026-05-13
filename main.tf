//=======================================================================================================\\
//                                         S3 State Backend Module                                       \\
//=======================================================================================================\\
module "s3" {
  source      = "./modules/s3"
  environment = var.environment
  s3_conf     = var.s3_conf
}

//=======================================================================================================\\
//                                         VPC Module                                                    \\
//=======================================================================================================\\
module "vpc" {
  source      = "./modules/vpc"
  region      = var.region
  environment = var.environment
  vpc_conf    = var.vpc_conf
}

//=======================================================================================================\\
//                                         ALB Module                                                    \\
//=======================================================================================================\\
module "alb" {
  source            = "./modules/alb"
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_conf          = var.alb_conf

  depends_on = [module.vpc]
}

//=======================================================================================================\\
//                                         EC2 Module                                                    \\
//=======================================================================================================\\
module "ec2" {
  source                 = "./modules/ec2"
  environment            = var.environment
  vpc_id                 = module.vpc.vpc_id
  private_app_subnet_ids = module.vpc.private_app_subnet_ids
  alb_security_group_id  = module.alb.alb_security_group_id
  target_group_arn       = module.alb.target_group_arn
  ec2_conf               = var.ec2_conf

  depends_on = [module.vpc, module.alb]
}

//=======================================================================================================\\
//                                         CI/CD Module                                                  \\
//=======================================================================================================\\
module "cicd" {
  source                  = "./modules/cicd"
  environment             = var.environment
  github_owner            = var.github_owner
  github_repo             = var.github_repo
  github_branch           = var.github_branch
  pipeline_bucket         = var.pipeline_bucket
  codestar_connection_arn = var.codestar_connection_arn
}
