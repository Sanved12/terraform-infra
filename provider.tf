terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # -----------------------------------------------------------------------
  # Remote State Backend — S3 + DynamoDB for locking
  #
  # The bucket and DynamoDB table are managed by modules/s3.
  # bucket_name and dynamodb_table come from var.s3_conf in terraform.tfvars.
  #
  # Bootstrap steps (first time only):
  #   1. Comment out this backend block and run: terraform apply
  #      (this creates the S3 bucket + DynamoDB table via the s3 module)
  #   2. Set bucket = var.s3_conf.bucket_name value below
  #   3. Uncomment this backend block and run: terraform init -migrate-state
  # -----------------------------------------------------------------------
  backend "s3" {
    bucket         = "sanved-bucket"
    key            = "test/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "sanved-bucket-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Environment = var.environment
      Repository  = "github.com/YOUR-ORG/YOUR-REPO"  # ← Replace this
    }
  }
}
