output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "frontend_service_name" {
  value = aws_ecs_service.frontend_service.name
}

output "backend_service_name" {
  value = aws_ecs_service.backend_service.name
}