output "codedeploy_app_name" {
  description = "The name of the CodeDeploy application"
  value       = aws_codedeploy_app.ecs_bluegreen_app.name
}

output "codedeploy_deployment_group_name" {
  description = "The name of the CodeDeploy deployment group for Backend"
  value       = aws_codedeploy_deployment_group.ecs_bluegreen_deployment_group_backend.deployment_group_name
}
