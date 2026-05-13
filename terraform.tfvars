//========== Common Global Variables ===========//
region      = "ap-south-1"
environment = "test"

//=======================================================================================================\\
//                                       S3 State Backend Configuration                                  \\
//=======================================================================================================\\
s3_conf = {
  bucket_name    = "sanved-bucket"
  dynamodb_table = "sanved-bucket-locks"
}

//=======================================================================================================\\
//                                       VPC Configuration                                               \\
//=======================================================================================================\\
vpc_conf = {
  vpc = {
    cidr_vpc = "10.0.0.0/16"
    additional_tags = {
      Owner = "sanved"
    }
  }

  nat_gateway = {
    additional_tags = {
      Owner = "sanved"
    }
  }

  subnets = {
    public_subnets = {
      name = "public-subnet"
      cidr = [
        "10.0.0.0/20",
        "10.0.16.0/20",
        "10.0.32.0/20",
      ]
      additional_tags = {
        Owner = "sanved"
        Tier  = "public-subnet"
      }
    }

    private_app_subnets = {
      name = "private-app-subnet"
      cidr = [
        "10.0.48.0/20",
        "10.0.64.0/20",
        "10.0.80.0/20",
      ]
      additional_tags = {
        Owner = "sanved"
        Tier  = "private-app-subnet"
      }
    }

    private_db_subnets = {
      name = "private-db-subnet"
      cidr = [
        "10.0.96.0/20",
        "10.0.112.0/20",
        "10.0.128.0/20"
      ]
      additional_tags = {
        Owner = "sanved"
        Tier  = "private-db-subnet"
      }
    }
  }
}

//=======================================================================================================\\
//                                       ALB Configuration                                               \\
//=======================================================================================================\\
alb_conf = {
  enable_deletion_protection = false
  additional_tags = {
    Owner = "sanved"
  }
  target_group = {
    port              = 80
    protocol          = "HTTP"
    health_check_path = "/health"
  }
}

//=======================================================================================================\\
//                                       EC2 Configuration                                               \\
//=======================================================================================================\\
ec2_conf = {
  ami_id         = "ami-0f58b397bc5c1f2e8"  # Amazon Linux 2023 — ap-south-1
  instance_type  = "t3.micro"
  instance_count = 2
  app_port       = 80
  public_key     = ""
  additional_tags = {
    Owner = "sanved"
  }
  root_volume = {
    type    = "gp3"
    size_gb = 20
  }
}

//=======================================================================================================\\
//                                   CodePipeline Configuration                                          \\
//=======================================================================================================\\
github_owner    = "Sanved12"
github_repo     = "terraform-infra"
github_branch   = "main"
pipeline_bucket = "sanved-pipeline-artifacts"
