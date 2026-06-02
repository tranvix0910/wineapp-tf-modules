output "repository_name" {
  description = "The name of the CodeCommit repository"
  value       = aws_codecommit_repository.app_repo.repository_name
}

output "repository_arn" {
  description = "The ARN of the CodeCommit repository"
  value       = aws_codecommit_repository.app_repo.arn
}

output "clone_url_http" {
  description = "The URL to use for cloning the repository over HTTPS"
  value       = aws_codecommit_repository.app_repo.clone_url_http
}

output "clone_url_ssh" {
  description = "The URL to use for cloning the repository over SSH"
  value       = aws_codecommit_repository.app_repo.clone_url_ssh
}
