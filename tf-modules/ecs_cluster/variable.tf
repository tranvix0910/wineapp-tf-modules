variable "ecs_region" {
  type = string
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "ecs_task_role_arn" {
  type = string
}

variable "frontend_ecr_image_url" {
  type = string
}

variable "alb_dns_backend" {
  type = string
}

variable "ecs_subnet_ids" {
  type = list(string)
}

variable "ecs_security_group_ids" {
  type = list(string)
}

variable "backend_ecr_image_url" {
  type = string
}

variable "mongodb_connection_string_secret_arn" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "frontend_log_group_name" {
  type = string
}

variable "backend_log_group_name" {
  type = string
}

variable "frontend_container_name" {
  type = string
}

variable "backend_container_name" {
  type = string
}

variable "frontend_target_group_blue_arn" {
  type = string
}

variable "backend_target_group_blue_arn" {
  type = string
}
