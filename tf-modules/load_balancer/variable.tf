variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "acm_certificate_arn" {
  description = "The ACM Certificate ARN"
  type        = string
}

variable "load_balancer_security_group_ids" {
  description = "The security groups for the VPC"
  type        = list(string)
}

variable "load_balancer_subnets_ids" {
  description = "The subnets for the load balancer"
  type        = list(string)
}

variable "project_name" {
  type        = string
  description = "The name of the project"
  default     = "wine-app"
}

variable "domain_name" {
  type        = string
  description = "The name of the domain"
}

variable "route53_zone_id" {
  type        = string
  description = "The ID of the hosted zone of the ALB"
}

# variable "project_alb_zone_id" {
#   type        = string
#   description = "The ID of the hosted zone of the ALB"
# }

# variable "project_alb_dns_name" {
#   type        = string
#   description = "The DNS name of the ALB"
# }