output "artifacts_bucket_id" {
  description = "The S3 Bucket name used for Pipeline artifacts"
  value       = aws_s3_bucket.artifacts_bucket.id
}

output "artifacts_bucket_arn" {
  description = "The S3 Bucket ARN used for Pipeline artifacts"
  value       = aws_s3_bucket.artifacts_bucket.arn
}

output "backend_pipeline_arn" {
  description = "ARN of the Backend CodePipeline"
  value       = aws_codepipeline.backend_pipeline.arn
}

output "frontend_pipeline_arn" {
  description = "ARN of the Frontend CodePipeline"
  value       = aws_codepipeline.frontend_pipeline.arn
}
