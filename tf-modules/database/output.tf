output "mongodb_connection_string" {
  description = "The connection string for the database"
  value       = aws_secretsmanager_secret_version.mongodb_connection_string_version.secret_string
}

output "mongodb_cluster_endpoint" {
  description = "The endpoint for the database"
  value       = aws_docdb_cluster.mongodb_cluster.endpoint
}

output "mongodb_secret_arn" {
  description = "The ARN of the secret for the database"
  value       = aws_secretsmanager_secret.mongodb_secret.arn
}

output "mongodb_connection_string_arn" {
  description = "The ARN of the secret for the database"
  value       = aws_secretsmanager_secret.mongodb_connection_string.arn
}

