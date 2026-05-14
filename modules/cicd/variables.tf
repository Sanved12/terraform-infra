variable "environment" {
  description = "Environment name (e.g. poc, dev, staging, prod)"
}

variable "cicd_conf" {
  description = "All CI/CD related configurations such as: GitHub source, pipeline artifact bucket, CodeStar connection, Terraform version"
}
