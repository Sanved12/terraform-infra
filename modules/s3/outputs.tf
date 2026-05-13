output "bucket_name" {
  description = "State bucket name — use this in provider.tf backend block"
  value       = aws_s3_bucket.state.bucket
}

output "dynamodb_table_name" {
  description = "DynamoDB lock table name"
  value       = aws_dynamodb_table.lock.name
}
