variable "vpc_id" {
  description = "The ID of the VPC"
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