output "backend_project_name" {
  description = "Name of the Backend CodeBuild project"
  value       = aws_codebuild_project.backend_build.name
}

output "frontend_project_name" {
  description = "Name of the Frontend CodeBuild project"
  value       = aws_codebuild_project.frontend_build.name
}

output "backend_project_arn" {
  description = "ARN of the Backend CodeBuild project"
  value       = aws_codebuild_project.backend_build.arn
}

output "frontend_project_arn" {
  description = "ARN of the Frontend CodeBuild project"
  value       = aws_codebuild_project.frontend_build.arn
}
