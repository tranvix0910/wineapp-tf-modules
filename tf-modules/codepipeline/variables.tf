variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Application environment (e.g. dev, prod)"
  type        = string
}

variable "backend_codecommit_repo_name" {
  description = "The name of the Backend CodeCommit repository"
  type        = string
}

variable "backend_codecommit_repo_arn" {
  description = "The ARN of the Backend CodeCommit repository"
  type        = string
}

variable "frontend_codecommit_repo_name" {
  description = "The name of the Frontend CodeCommit repository"
  type        = string
}

variable "frontend_codecommit_repo_arn" {
  description = "The ARN of the Frontend CodeCommit repository"
  type        = string
}

variable "backend_codebuild_project_name" {
  description = "Name of the Backend CodeBuild project"
  type        = string
}

variable "frontend_codebuild_project_name" {
  description = "Name of the Frontend CodeBuild project"
  type        = string
}

variable "codedeploy_app_name" {
  description = "The name of the CodeDeploy application"
  type        = string
}

variable "codedeploy_deployment_group_name" {
  description = "The name of the CodeDeploy deployment group"
  type        = string
}
