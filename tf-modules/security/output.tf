output "public_sg_id" {
  value = module.public_sg.security_group_id
}

output "private_sg_id" {
  value = module.private_sg.security_group_id
}

output "bastion_sg_id" {
  value = module.bastion_sg.security_group_id
}

output "database_sg_id" {
  value = module.database_sg.security_group_id
}
