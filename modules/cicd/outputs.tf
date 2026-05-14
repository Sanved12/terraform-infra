output "codepipeline_name" {
  description = "Name of the CodePipeline"
  value       = aws_codepipeline.terraform.name
}

output "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  value       = aws_codebuild_project.terraform.name
}

output "pipeline_artifact_bucket" {
  description = "S3 bucket used for pipeline artifacts"
  value       = aws_s3_bucket.pipeline_artifacts.bucket
}

output "codestar_connection_arn" {
  description = "CodeStar connection ARN — must be manually activated in AWS Console before pipeline runs"
  value       = var.codestar_connection_arn
}
