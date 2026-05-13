//============= All the variables will be populated by the calling function values =============//

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "s3_conf" {
  description = "S3 state backend configuration"
  type = object({
    bucket_name    = string
    dynamodb_table = string
  })
}
