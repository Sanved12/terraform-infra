output "bucket_name" {
  description = "State bucket name — use this in provider.tf backend block"
  value       = aws_s3_bucket.state.bucket
}
