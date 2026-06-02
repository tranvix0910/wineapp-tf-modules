variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Application environment (e.g. dev, prod)"
  type        = string
}

variable "backend_ecr_repo_url" {
  description = "ECR Repository URL for Backend without tag (e.g., 1234567890.dkr.ecr.ap-southeast-1.amazonaws.com/wineapp-backend)"
  type        = string
}

variable "frontend_bucket_id" {
  description = "S3 Bucket ID for Frontend hosting"
  type        = string
}

variable "frontend_bucket_arn" {
  description = "S3 Bucket ARN for Frontend hosting"
  type        = string
}

variable "cloudfront_distribution_id" {
  description = "CloudFront Distribution ID for cache invalidation"
  type        = string
}

variable "artifacts_bucket_arn" {
  description = "ARN of the S3 Bucket used for storing Pipeline artifacts"
  type        = string
}

variable "artifacts_bucket_id" {
  description = "Name of the S3 Bucket used for storing Pipeline artifacts"
  type        = string
}

variable "backend_build_role_arn" {
  description = "ARN of the IAM Role for Backend CodeBuild"
  type        = string
}

variable "frontend_build_role_arn" {
  description = "ARN of the IAM Role for Frontend CodeBuild"
  type        = string
}

