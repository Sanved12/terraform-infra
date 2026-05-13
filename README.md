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
  Source stage — pulls code from GitHub via webhook
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
│   └── ec2/          # EC2 instances, security group, TG attachments
├── main.tf           # Root module
├── variables.tf      # Variable declarations
├── outputs.tf        # Outputs
├── provider.tf       # AWS provider + S3 backend
├── terraform.tfvars  # All variable values  ← fill this in
├── codepipeline.tf   # CodePipeline + CodeBuild infrastructure
├── buildspec.yml     # CodeBuild build instructions
└── .gitignore
```

---

## One-Time Setup

### 1. Create S3 Backend Bucket + DynamoDB Lock Table

```bash
BUCKET="your-terraform-state-bucket"
REGION="ap-south-1"

aws s3 mb s3://$BUCKET --region $REGION
aws s3api put-bucket-versioning --bucket $BUCKET --versioning-configuration Status=Enabled

aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region $REGION
```

Update `provider.tf` — replace `YOUR-TERRAFORM-STATE-BUCKET` with your bucket name.

### 2. Create a GitHub Personal Access Token

Go to GitHub → Settings → Developer settings → Personal access tokens → Generate new token.

Required scopes: `repo`, `admin:repo_hook`

### 3. Fill in `terraform.tfvars`

```hcl
github_owner       = "your-github-username-or-org"
github_repo        = "your-repo-name"
github_branch      = "main"
github_oauth_token = "ghp_xxxxxxxxxxxx"
pipeline_bucket    = "your-unique-pipeline-artifacts-bucket"
```

### 4. Deploy Everything (First Time)

Run Terraform locally once to create the pipeline infrastructure:

```bash
terraform init
terraform apply -var-file="terraform.tfvars"
```

This creates the VPC/ALB/EC2 **and** the CodePipeline. After this, every push to `main` triggers the pipeline automatically.

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
| `vpc_conf.vpc.cidr_vpc` | VPC CIDR block |
| `ec2_conf.instance_type` | EC2 instance type |
| `ec2_conf.instance_count` | Number of EC2 instances |
| `ec2_conf.public_key` | SSH public key string |
| `alb_conf.target_group.health_check_path` | Health check endpoint |
