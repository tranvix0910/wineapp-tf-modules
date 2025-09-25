output "frontend_target_group_blue_arn" {
  value = aws_lb_target_group.frontend_target_group_blue.arn
}

output "backend_target_group_blue_arn" {
  value = aws_lb_target_group.backend_target_group_blue.arn
}

output "frontend_listener_arn" {
  value = aws_lb_listener.frontend_listener.arn
}

output "frontend_target_group_blue_name" {
  value = aws_lb_target_group.frontend_target_group_blue.name
}

output "frontend_target_group_green_name" {
  value = aws_lb_target_group.frontend_target_group_green.name
}

output "backend_target_group_blue_name" {
  value = aws_lb_target_group.backend_target_group_blue.name
}

output "backend_target_group_green_name" {
  value = aws_lb_target_group.backend_target_group_green.name
}

output "alb_arn" {
  value = aws_lb.load_balancer.arn
}

output "alb_dns" {
  value = aws_lb.load_balancer.dns_name
}

output "alb_dns_backend" {
  value = "http://${aws_lb.load_balancer.dns_name}:80"
}