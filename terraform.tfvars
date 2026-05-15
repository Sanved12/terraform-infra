//========== Common Global Variables ===========//
region      = "ap-south-1" 
environment = "test"

//=======================================================================================================\\
//                                       S3 State Backend Configuration                                  \\
//=======================================================================================================\\
s3_conf = {
  bucket_name = "sanved-bucket"
}

//=======================================================================================================\\
//                                       VPC Configuration                                               \\
//=======================================================================================================\\

# VPC configuration — pass CIDR values for VPC and subnets.
# The number of subnet CIDRs provided equals the number of subnets created in subsequent AZs of the selected region.

vpc_conf = {

  # VPC CIDR and tags
  vpc = {
    cidr_vpc = "10.0.0.0/16"
    additional_tags = {
      Owner = "sanved"
    }
  }

  # NAT Gateway tags
  nat_gateway = {
    additional_tags = {
      Owner = "sanved"
    }
  }

  subnets = {

    # Public subnets — one per AZ
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

    # Private app subnets — one per AZ
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

    # Private DB subnets — isolated, no route to internet
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
  ami_id         = "ami-0f58b397bc5c1f2e8" # Amazon Linux 2023 — ap-south-1
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

cicd_conf = {
  github_owner            = "Sanved12"
  github_repo             = "terraform-infra"
  github_branch           = "main"
  pipeline_bucket         = "sanved-pipeline-artifacts"
  codestar_connection_arn = "arn:aws:codeconnections:us-east-1:168312023901:connection/170b7e94-c0e9-423c-a201-9386ccd5c857"
  tf_version              = "1.10.3"
}

