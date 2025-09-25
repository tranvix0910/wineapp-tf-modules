output "bastion_host_public_ip" {
  value = module.aws_bastion.bastion_host_public_ip
}

output "mongodb_endpoint" {
  value = module.database.mongodb_cluster_endpoint
}

output "mongodb_password_secret_arn" {
  value = module.database.mongodb_secret_arn
}

output "mongodb_connection_string_secret_arn" {
  value = module.database.mongodb_connection_string_arn
}

# output "alb_dns_name" {
#   value = module.aws_load_balance.alb_dns
# }
