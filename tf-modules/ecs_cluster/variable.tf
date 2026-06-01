variable "ecs_region" {
  type = string
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "ecs_task_role_arn" {
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

variable "backend_log_group_name" {
  type = string
}

variable "backend_container_name" {
  type = string
}

variable "backend_target_group_blue_arn" {
  type = string
}

variable "project_name" {
  type        = string
  description = "The name of the project"
  default     = "wine-app"
}
