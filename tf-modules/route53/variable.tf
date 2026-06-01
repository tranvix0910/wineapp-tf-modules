variable "domain_name" {
  description = "The root domain name (e.g., tranvix.click)"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "wine-app"
}

variable "project_alb_dns_name" {
  description = "The DNS name of the Application Load Balancer to create the alias record"
  type        = string
}

variable "project_alb_zone_id" {
  description = "The Hosted Zone ID of the Application Load Balancer to create the alias record"
  type        = string
}
