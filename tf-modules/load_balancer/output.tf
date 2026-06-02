output "alb_arn" {
  value = module.project_alb.arn
}

output "alb_dns_name" {
  value = module.project_alb.dns_name
}

output "listener_arn" {
  value = module.project_alb.listeners["http-80"].arn
}

output "backend_target_group_blue_arn" {
  value = module.project_alb.target_groups["backend_blue"].arn
}

output "backend_target_group_green_arn" {
  value = module.project_alb.target_groups["backend_green"].arn
}

output "backend_target_group_blue_name" {
  value = module.project_alb.target_groups["backend_blue"].name
}

output "backend_target_group_green_name" {
  value = module.project_alb.target_groups["backend_green"].name
}