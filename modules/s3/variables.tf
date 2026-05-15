variable "environment" {
  description = "Environment name (e.g. poc, dev, staging, prod)"
}

variable "s3_conf" {
  description = "S3 related configuration for the creation of the state bucket"
}
