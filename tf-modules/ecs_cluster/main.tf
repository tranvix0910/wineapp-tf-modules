# Create ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
}

# Create Log Group
resource "aws_cloudwatch_log_group" "backend_log_group" {
  name              = "ecs/${var.project_name}-${var.backend_container_name}"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "backend_task_definition" {
  family                   = "${var.project_name}-backend-task-definition"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  container_definitions = templatefile("${path.module}/task_definitions/backend.json.tpl", {
    backend_container_name               = var.backend_container_name
    backend_ecr_image_url                = var.backend_ecr_image_url
    mongodb_connection_string_secret_arn = var.mongodb_connection_string_secret_arn
    awslogs_group                        = aws_cloudwatch_log_group.backend_log_group.name
    awslogs_region                       = var.ecs_region
  })
}

resource "aws_ecs_service" "backend_service" {

  name = "${var.project_name}-${var.backend_container_name}"

  network_configuration {
    subnets          = var.ecs_subnet_ids
    security_groups  = var.ecs_security_group_ids
    assign_public_ip = false
  }

  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.backend_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = var.backend_target_group_blue_arn
    container_name   = var.backend_container_name
    container_port   = 4000
  }

  lifecycle {
    ignore_changes = [
      task_definition,
      load_balancer
    ]
  }
}

