//========== Common Global Variables ===========//
region      = "ap-south-1" # AWS region where the resources will be created
environment = "poc"

# VPC configuration to create new vpc or use existing VPC and other network related infra depending on the value flag vpc in create 
# section above. If vpc=true, vpc and subnets sub-section of vpc_conf will be used for passing the valid CIDR values VPC and subnets, otherwise, existing_vpc
# sub-section of vpc_conf will be used for passing the existing VPC and subnet name tags for data call

vpc_conf = {

  # VPC configuration for creating new vpc when flag vpc=true in create section above 
  vpc = {
    # Pass the VPC's CIDR range
    cidr_vpc = "10.0.0.0/16"
    # Pass the tags that should be associated with this VPC
    additional_tags = {
      Owner = "dataviv"
    }
  }
  # Pass the tags that should be associated with this NAT
  nat_gateway = {
    additional_tags = {
      Owner = "dataviv"
    }
  }

  # Public, Private and DB subnet configuration for creating new set of various subnets 
  subnets = {
    # Configuration of public subnets to be created
    # The number of subnet CIDRs provided will be equal to no of subnets to be created in subsequent AZs of selected reagion

    public_subnets = {
      name = "public-subnet"
      cidr = [
        "10.0.0.0/20",
        "10.0.16.0/20",
        "10.0.32.0/20",
      ]
      additional_tags = {
        Owner = "dataviv"
        Tier  = "public-subnet"
      }
    }

    # Configuration of private data and control plane (which is basically app subnets) subnets to be created
    # The number of subnet CIDRs provided will be equal to no of subnets to be created in subsequent AZs of selected reagion
    private_app_subnets = {
      name = "private-app-subnet"
      cidr = [
        "10.0.48.0/20",
        "10.0.64.0/20",
        "10.0.80.0/20",
      ]
      additional_tags = {
        Owner = "dataviv"
        Tier  = "private-app-subnet"
      }
    }

    # Configuration of private data and control plane subnets to be created
    # The number of subnet CIDRs provided will be equal to no of subnets to be created in subsequent AZs of selected reagion
    private_db_subnets = {
      ## Configuration of DB subnets to be created
      name = "private-db-subnet"
      cidr = [
        "10.0.96.0/20",
        "10.0.112.0/20",
        "10.0.128.0/20"
      ]
      additional_tags = {
        Owner = "dataviv"
        Tier  = "private-db-subnet"
      }
    }
  }
}