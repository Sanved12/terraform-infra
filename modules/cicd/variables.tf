variable "environment" {
  description = "Environment name"
  type        = string
}

variable "github_owner" {
  description = "GitHub repository owner (org or username)"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "github_branch" {
  description = "Branch to trigger the pipeline"
  type        = string
  default     = "main"
}

variable "pipeline_bucket" {
  description = "S3 bucket name for CodePipeline artifacts (must be globally unique)"
  type        = string
}

variable "tf_version" {
  description = "Terraform version to install in CodeBuild"
  type        = string
  default     = "1.7.5"
}
