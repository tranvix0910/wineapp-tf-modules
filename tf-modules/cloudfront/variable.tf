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

variable "alb_dns_name" {
  type        = string
  description = "DNS name of the Application Load Balancer to route /api/* traffic"
}

variable "domain_name" {
  type        = string
  description = "The root domain name"
}

variable "acm_certificate_arn" {
  type        = string
  description = "The ARN of the ACM certificate to attach to CloudFront"
}
variable "route53_zone_id" {
  type        = string
  description = "The Route53 Zone ID to create CloudFront alias records"
}
