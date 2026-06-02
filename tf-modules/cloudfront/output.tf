output "cloudfront_arn" {
  description = "The ARN of the CloudFront distribution (used for S3 bucket policy)"
  value       = aws_cloudfront_distribution.frontend_distribution.arn
}

output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.frontend_distribution.domain_name
}

output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.frontend_distribution.id
}
