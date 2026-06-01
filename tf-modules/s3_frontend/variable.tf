variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "wine-app"
}

variable "environment" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "cloudfront_arn" {
  description = "The ARN of the CloudFront distribution to allow access via OAC. Leave empty if not yet created."
  type        = string
  default     = ""
}