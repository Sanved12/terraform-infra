variable "environment" {
  description = "Environment name (e.g. poc, dev, staging, prod)"
}

variable "github_owner" {
  description = "GitHub repository owner (org or username)"
}

variable "github_repo" {
  description = "GitHub repository name"
}

variable "github_branch" {
  description = "Branch to trigger the pipeline"
  default     = "main"
}

variable "pipeline_bucket" {
  description = "S3 bucket name for CodePipeline artifacts (must be globally unique)"
}

variable "codestar_connection_arn" {
  description = "Existing CodeStar connection ARN to use for GitHub source"
}

variable "tf_version" {
  description = "Terraform version to install in CodeBuild"
  default     = "1.7.5"
}
