output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.frontend_bucket.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.frontend_bucket.arn
}

output "bucket_regional_domain_name" {
  description = "The bucket region-specific domain name (used for CloudFront origin)"
  value       = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
}
