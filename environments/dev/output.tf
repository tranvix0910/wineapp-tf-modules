output "bastion_host_public_ip" {
  value = module.aws_bastion_instance.bastion_host_public_ip
}

# output "mongodb_endpoint" {
#   value = module.database.mongodb_cluster_endpoint
# }

# output "mongodb_password_secret_arn" {
#   value = module.database.mongodb_secret_arn
# }

# output "mongodb_connection_string_secret_arn" {
#   value = module.database.mongodb_connection_string_arn
# }

output "alb_dns_name" {
  value = module.aws_load_balance.alb_dns_name
}

output "cloudfront_domain_name" {
  value = module.aws_cloudfront.cloudfront_domain_name
}

output "codecommit_clone_url_http" {
  description = "The HTTP clone URL for the CodeCommit repository"
  value       = module.aws_codecommit.clone_url_http
}

output "codecommit_clone_url_ssh" {
  description = "The SSH clone URL for the CodeCommit repository"
  value       = module.aws_codecommit.clone_url_ssh
}

