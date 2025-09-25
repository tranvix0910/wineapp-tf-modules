resource "aws_codedeploy_app" "ecs_bluegreen_app" {
  compute_platform = "ECS"
  name             = var.codedeploy_app_name
}

# Deployment Group - Frontend
resource "aws_codedeploy_deployment_group" "ecs_bluegreen_deployment_group_frontend" {
  app_name               = aws_codedeploy_app.ecs_bluegreen_app.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = var.codedeploy_deployment_group_name_frontend  
  service_role_arn       = var.codedeploy_ecs_task_role_arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.codedeploy_ecs_cluster_name
    service_name = var.codedeploy_ecs_service_frontend_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.codedeploy_frontend_listener_arn]
      }

      target_group {
        name = var.codedeploy_frontend_target_group_blue_name
      }

      target_group {
        name = var.codedeploy_frontend_target_group_green_name
      }
    }
  }
}

# Deployment Group - Backend
resource "aws_codedeploy_deployment_group" "ecs_bluegreen_deployment_group_backend" {
  app_name               = aws_codedeploy_app.ecs_bluegreen_app.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = var.codedeploy_deployment_group_name_backend
  service_role_arn       = var.codedeploy_ecs_task_role_arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.codedeploy_ecs_cluster_name
    service_name = var.codedeploy_ecs_service_backend_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.codedeploy_frontend_listener_arn]
      }

      target_group {
        name = var.codedeploy_backend_target_group_blue_name
      }

      target_group {
        name = var.codedeploy_backend_target_group_green_name
      }
    }
  }
}