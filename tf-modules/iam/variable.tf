variable "task_execution_role_name" {
  description = "The name of the task execution role"
  type        = string
}

variable "task_execution_policy_name" {
  description = "The name of the task execution policy"
  type        = string
}

variable "task_role_name" {
  description = "The name of the task role"
  type        = string
}

variable "task_role_policy_name" {
  description = "The name of the task role policy"
  type        = string
}

variable "codedeploy_service_role_name" {
  description = "The name of the CodeDeploy service role"
  type        = string
}

variable "codedeploy_service_policy_name" {
  description = "The name of the CodeDeploy service policy"
  type        = string
}

variable "project_name" {
  description = "The project name"
  type        = string
}

variable "environment" {
  description = "The environment (e.g. dev, prod)"
  type        = string
}

variable "backend_build_role_name" {
  description = "The name of the backend CodeBuild role"
  type        = string
}

variable "backend_build_policy_name" {
  description = "The name of the backend CodeBuild policy"
  type        = string
}

variable "frontend_build_role_name" {
  description = "The name of the frontend CodeBuild role"
  type        = string
}

variable "frontend_build_policy_name" {
  description = "The name of the frontend CodeBuild policy"
  type        = string
}









