variable "project_name" {
  type        = string
  description = "The name of the project"
  default     = "wine-app"
}

variable "environment" {
  type        = string
  description = "The environment (e.g. dev, prod)"
}

variable "s3_bucket_regional_domain_name" {
  type        = string
  description = "The regional domain name of the S3 bucket to serve as the CloudFront origin"
}
