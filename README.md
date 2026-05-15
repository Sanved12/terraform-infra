# Terraform Infrastructure — VPC + ALB + EC2

Terraform setup for AWS infrastructure (VPC, ALB, EC2) with automated CI/CD via AWS CodePipeline + CodeBuild.

## Architecture

```
Internet
   │
   ▼
[ALB] ── Public Subnets (3 AZs)
   │
   ▼
[EC2 App Servers] ── Private App Subnets (3 AZs)
   │
   ▼
[NAT Gateway] ── Internet egress for private subnets

[Private DB Subnets] ── Isolated, no route to internet
```

## CI/CD Flow

```
Push to main branch on GitHub
        │
        ▼
  [CodePipeline]
  Source stage — pulls code from GitHub via CodeStar Connection
        │
        ▼
  [CodeBuild]
  terraform init
  terraform plan
  terraform apply
```

Any push to the `main` branch automatically triggers the pipeline and applies infrastructure changes.

---

## Project Structure

```
terraform-infra/
├── modules/
│   ├── vpc/          # VPC, subnets, IGW, NAT, route tables
│   ├── alb/          # ALB, target group, listener, security group
│   ├── ec2/          # EC2 instances, security group, TG attachments
│   ├── cicd/         # CodePipeline, CodeBuild, IAM roles
│   └── s3/           # S3 state bucket, DynamoDB lock table
├── main.tf           # Root module
├── variables.tf      # Variable declarations
├── outputs.tf        # Outputs
├── provider.tf       # AWS provider + S3 backend
├── terraform.tfvars  # All variable values  ← fill this in
├── buildspec.yml     # CodeBuild build instructions
└── .gitignore
```

---

## One-Time Setup

### 1. Create a GitHub CodeStar Connection

Go to AWS Console → CodePipeline → Settings → Connections → Create connection.

Select **GitHub**, complete the OAuth handshake, and copy the connection ARN.

> The connection must be manually activated in the AWS Console before the pipeline can run.

### 2. Fill in `terraform.tfvars`

```hcl
region      = "ap-south-1"
environment = "dev"

s3_conf = {
  bucket_name = "your-terraform-state-bucket"
}

vpc_conf = {
  availability_zones = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  vpc = {
    cidr_vpc        = "10.0.0.0/16"
    additional_tags = {}
  }
  nat_gateway = {
    additional_tags = {}
  }
  subnets = {
    public_subnets = {
      name            = "public-subnet"
      cidr            = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
      additional_tags = {}
    }
    private_app_subnets = {
      name            = "private-app-subnet"
      cidr            = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
      additional_tags = {}
    }
    private_db_subnets = {
      name            = "private-db-subnet"
      cidr            = ["10.0.96.0/20", "10.0.112.0/20", "10.0.128.0/20"]
      additional_tags = {}
    }
  }
}

alb_conf = {
  enable_deletion_protection = false
  additional_tags            = {}
  target_group = {
    port              = 80
    protocol          = "HTTP"
    health_check_path = "/health"
  }
}

ec2_conf = {
  ami_id         = "ami-xxxxxxxxxxxxxxxxx"
  instance_type  = "t3.micro"
  instance_count = 2
  app_port       = 80
  public_key     = ""
  additional_tags = {}
  root_volume = {
    type    = "gp3"
    size_gb = 20
  }
}

cicd_conf = {
  github_owner            = "your-github-username-or-org"
  github_repo             = "your-repo-name"
  github_branch           = "main"
  pipeline_bucket         = "your-unique-pipeline-artifacts-bucket"
  codestar_connection_arn = "arn:aws:codeconnections:REGION:ACCOUNT_ID:connection/XXXXXXXX"
  tf_version              = "1.7.5"
}
```

### 3. Update the S3 Backend in `provider.tf`

Replace the `backend "s3"` block values with your state bucket name and DynamoDB table:

```hcl
backend "s3" {
  bucket       = "your-terraform-state-bucket"
  key          = "env/terraform.tfstate"
  region       = "ap-south-1"
  use_lockfile = true
  encrypt      = true
}
```

### 4. Deploy Everything (First Time)

The `s3` module creates the state bucket and DynamoDB lock table. On the very first run, bootstrap with a local backend or create the bucket manually, then run:

```bash
terraform init
terraform apply -var-file="terraform.tfvars"
```

This creates all infrastructure — VPC, ALB, EC2, S3 state backend, and the CodePipeline. After this, every push to `main` triggers the pipeline automatically.

---

## Local Development

```bash
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"

# Destroy
terraform destroy -var-file="terraform.tfvars"
```

---

## Customization

Edit `terraform.tfvars`:

| Variable | Description |
|----------|-------------|
| `vpc_conf.availability_zones` | List of AZs to deploy subnets into |
| `vpc_conf.vpc.cidr_vpc` | VPC CIDR block |
| `ec2_conf.instance_type` | EC2 instance type |
| `ec2_conf.instance_count` | Number of EC2 instances |
| `ec2_conf.ami_id` | AMI ID (region-specific) |
| `ec2_conf.public_key` | SSH public key string (leave empty to skip key pair) |
| `alb_conf.target_group.health_check_path` | Health check endpoint |
| `cicd_conf.codestar_connection_arn` | ARN of the GitHub CodeStar Connection |
| `cicd_conf.tf_version` | Terraform version used in CodeBuild |
