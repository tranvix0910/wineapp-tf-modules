output "task_execution_role_arn" {
  value = aws_iam_role.task_execution_role.arn
}

output "task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "codedeploy_service_role_arn" {
  value = aws_iam_role.codedeploy_service_role.arn
}

output "backend_build_role_arn" {
  value = aws_iam_role.backend_build_role.arn
}

output "frontend_build_role_arn" {
  value = aws_iam_role.frontend_build_role.arn
}