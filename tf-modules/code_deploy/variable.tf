variable "codedeploy_app_name" {
    type = string
}

variable "codedeploy_deployment_group_name_frontend" {
    type = string
}

variable "codedeploy_deployment_group_name_backend" {
    type = string
}

variable "codedeploy_ecs_task_role_arn" {
  type = string
}

variable "codedeploy_ecs_cluster_name" {
  type = string
}

variable "codedeploy_ecs_service_frontend_name" {
  type = string
}

variable "codedeploy_ecs_service_backend_name" {
  type = string
}

variable "codedeploy_frontend_listener_arn" {
  type = string
}

variable "codedeploy_frontend_target_group_blue_name" {
  type = string
}

variable "codedeploy_frontend_target_group_green_name" {
    type=string
}

variable "codedeploy_backend_target_group_blue_name" {
    type=string
}

variable "codedeploy_backend_target_group_green_name" {
    type=string
}
