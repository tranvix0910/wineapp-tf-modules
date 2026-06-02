output "backend_repository_name" {
  description = "The name of the Backend CodeCommit repository"
  value       = aws_codecommit_repository.backend_repo.repository_name
}

output "backend_repository_arn" {
  description = "The ARN of the Backend CodeCommit repository"
  value       = aws_codecommit_repository.backend_repo.arn
}

output "backend_clone_url_http" {
  description = "The HTTP clone URL for the Backend CodeCommit repository"
  value       = aws_codecommit_repository.backend_repo.clone_url_http
}

output "backend_clone_url_ssh" {
  description = "The SSH clone URL for the Backend CodeCommit repository"
  value       = aws_codecommit_repository.backend_repo.clone_url_ssh
}

output "frontend_repository_name" {
  description = "The name of the Frontend CodeCommit repository"
  value       = aws_codecommit_repository.frontend_repo.repository_name
}

output "frontend_repository_arn" {
  description = "The ARN of the Frontend CodeCommit repository"
  value       = aws_codecommit_repository.frontend_repo.arn
}

output "frontend_clone_url_http" {
  description = "The HTTP clone URL for the Frontend CodeCommit repository"
  value       = aws_codecommit_repository.frontend_repo.clone_url_http
}

output "frontend_clone_url_ssh" {
  description = "The SSH clone URL for the Frontend CodeCommit repository"
  value       = aws_codecommit_repository.frontend_repo.clone_url_ssh
}
