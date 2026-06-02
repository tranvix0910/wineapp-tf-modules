output "bastion_host_public_ip" {
  value       = module.ec2_instance.public_ip
  description = "Public IP Basion Host"
}

output "bastion_host_private_ip" {
  value       = module.ec2_instance.private_ip
  description = "Private IP Basion Host"
}
