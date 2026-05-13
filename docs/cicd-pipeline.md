# CI/CD Pipeline — Automated Terraform Deployment via AWS CodePipeline + CodeBuild

## Problem Statement

The infrastructure (VPC, ALB, EC2) is managed through Terraform. Every time a change is made
to the Terraform code, it had to be applied manually by running `terraform apply` locally.
This is error-prone, not auditable, and does not scale in a team environment.

**Goal:** Automate the Terraform workflow so that any code push to the `main` branch on GitHub
automatically triggers a pipeline that runs `terraform init → plan → apply` without any manual
intervention.

---

## Approach

Use AWS-native CI/CD services to build a fully automated pipeline:

```
Developer pushes code to GitHub (main branch)
              │
              ▼
     AWS CodePipeline (triggered via CodeStar Connection webhook)
              │
        ┌─────┴─────┐
        │  Stage 1  │  Source — pulls latest code from GitHub
        └─────┬─────┘
              │
        ┌─────┴─────┐
        │  Stage 2  │  Build — CodeBuild runs terraform init, plan, apply
        └─────┬─────┘
              │
              ▼
     Infrastructure updated on AWS
```

### Why CodeStar Connection instead of OAuth token?

GitHub OAuth tokens (classic) are being deprecated by AWS CodePipeline V2. CodeStar
Connections use a secure app-based integration with GitHub that does not require storing
a personal access token. It must be created once in the AWS Console and activated manually
before the pipeline can use it.

---

## Infrastructure Created

All CI/CD resources are defined in `modules/cicd/cicd.tf` and provisioned via the root
`main.tf` module block.

### 1. S3 Bucket — Artifact Store

```hcl
resource "aws_s3_bucket" "pipeline_artifacts" {
  bucket        = var.pipeline_bucket
  force_destroy = true
}
```

Stores the source code zip (output of the Source stage) and the compiled `tfplan` file
(output of the Build stage). Versioning and AES256 encryption are enabled.

### 2. IAM Role — CodeBuild

```hcl
resource "aws_iam_role" "codebuild" {
  name = "${var.environment}-codebuild-terraform-role"
  # trust: codebuild.amazonaws.com
}
```

Grants CodeBuild permission to:
- Read/write the artifact S3 bucket
- Write CloudWatch logs
- Call any AWS API (`Action: "*"`) — required because Terraform needs to create/modify/destroy
  any resource in the account
- Read SSM parameters under `/terraform-infra/*`

### 3. IAM Role — CodePipeline

```hcl
resource "aws_iam_role" "codepipeline" {
  name = "${var.environment}-codepipeline-terraform-role"
  # trust: codepipeline.amazonaws.com
}
```

Grants CodePipeline permission to:
- Read/write the artifact S3 bucket (to pass artifacts between stages)
- Start and monitor CodeBuild builds
- Use the CodeStar Connection to pull from GitHub

### 4. CodeBuild Project

```hcl
resource "aws_codebuild_project" "terraform" {
  name         = "${var.environment}-terraform-build"
  service_role = aws_iam_role.codebuild.arn
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"   # reads from repo root
  }
}
```

Runs on a `BUILD_GENERAL1_SMALL` Linux container using the `aws/codebuild/standard:7.0` image.
The Terraform version is injected as an environment variable (`TF_VERSION = 1.7.5`).
Build logs are sent to CloudWatch Logs under `/codebuild/{environment}-terraform`.

### 5. CodePipeline

```hcl
resource "aws_codepipeline" "terraform" {
  name          = "${var.environment}-terraform-pipeline"
  pipeline_type = "V2"

  trigger {
    provider_type = "CodeStarSourceConnection"
    git_configuration {
      push { branches { includes = [var.github_branch] } }
    }
  }
  ...
}
```

Pipeline type V2 is required to use the `trigger` block for push-based GitHub webhooks.
Two stages are defined:

| Stage | Name | What it does |
|---|---|---|
| 1 | `CodeSource-GitHub` | Pulls source code from GitHub via CodeStar Connection |
| 2 | `CodeBuild-Terraform` | Runs `buildspec.yml` — terraform init, plan, apply |

---

## buildspec.yml — What CodeBuild Runs

```yaml
phases:
  install:
    commands:
      - curl -sSLo terraform.zip https://releases.hashicorp.com/terraform/${TF_VERSION}/...
      - mv terraform /usr/local/bin/

  pre_build:
    commands:
      - terraform init -backend=true -input=false

  build:
    commands:
      - terraform plan -var-file="terraform.tfvars" -out=tfplan -input=false -no-color
      - terraform apply -auto-approve -input=false tfplan

  post_build:
    commands:
      - terraform output -no-color

artifacts:
  files:
    - tfplan   # saved to S3 artifact bucket for audit
```

| Phase | Purpose |
|---|---|
| `install` | Downloads and installs the pinned Terraform binary |
| `pre_build` | Initialises Terraform, connects to S3 backend for remote state |
| `build` | Creates an execution plan then applies it automatically |
| `post_build` | Prints all outputs for visibility in the build log |

---

## One-Time Setup (Pre-requisites)

These steps must be done once before the pipeline can run.

### 1. Create the CodeStar Connection

In the AWS Console:
```
Developer Tools → Connections → Create connection
Provider: GitHub → Connect to GitHub → Authorise → Save
```

Copy the connection ARN and set it in `terraform.tfvars`:
```hcl
codestar_connection_arn = "arn:aws:codeconnections:us-east-1:ACCOUNT_ID:connection/XXXX"
```

> The connection must be in **Available** status. A newly created connection starts in
> **Pending** and must be manually activated in the console before the pipeline can use it.

### 2. Create S3 Backend + DynamoDB Lock Table

```bash
aws s3 mb s3://your-terraform-state-bucket --region ap-south-1
aws s3api put-bucket-versioning --bucket your-terraform-state-bucket \
  --versioning-configuration Status=Enabled

aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ap-south-1
```

### 3. First-time Deploy (Local)

Run Terraform locally once to create the pipeline itself:

```bash
terraform init
terraform apply -var-file="terraform.tfvars"
```

After this, every push to `main` triggers the pipeline automatically.

---

## End-to-End Flow

```
1. Developer edits Terraform code locally
         │
         ▼
2. git push origin main
         │
         ▼
3. GitHub notifies AWS via CodeStar Connection webhook
         │
         ▼
4. CodePipeline Stage 1 — Source
   Pulls the repo zip from GitHub
   Stores it in S3 artifact bucket as source_output
         │
         ▼
5. CodePipeline Stage 2 — Build
   CodeBuild picks up source_output from S3
   Runs buildspec.yml:
     a. Downloads Terraform 1.7.5
     b. terraform init  → connects to S3 backend, downloads providers
     c. terraform plan  → computes diff against current state
     d. terraform apply → applies changes to AWS
     e. terraform output → prints resource info to build log
   Stores tfplan in S3 as build_output
         │
         ▼
6. Infrastructure is updated on AWS
```

---

## Variables Reference

| Variable | Description | Example |
|---|---|---|
| `github_owner` | GitHub username or org | `Sanved12` |
| `github_repo` | Repository name | `terraform-infra` |
| `github_branch` | Branch that triggers the pipeline | `main` |
| `pipeline_bucket` | Globally unique S3 bucket for artifacts | `sanved-pipeline-artifacts` |
| `codestar_connection_arn` | ARN of the activated CodeStar Connection | `arn:aws:codeconnections:...` |

---

## Outputs

After `terraform apply`, the following are printed:

| Output | Description |
|---|---|
| `codepipeline_name` | Name of the created pipeline |
| `codebuild_project_name` | Name of the CodeBuild project |
| `pipeline_artifact_bucket` | S3 bucket storing pipeline artifacts |
