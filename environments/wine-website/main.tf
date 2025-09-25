provider "aws" {
  region = "ap-southeast-1"
}

module "aws_ecs_cluster" {

  source = "../../tf-modules/ecs_cluster"

  ecs_region = "ap-southeast-1"
  ecs_cluster_name = "wine-website-cluster"
  ecs_subnet_ids = module.aws_vpc.private_subnet_ids
  ecs_security_group_ids = [
    module.aws_security_group.private_sg_id
  ]

  ecs_task_execution_role_arn = module.aws_iam.task_execution_role_arn
  ecs_task_role_arn = module.aws_iam.task_role_arn

  # Frontend
  frontend_log_group_name = "ecs/wine-website-frontend-log-group"
  frontend_container_name = "wine-website-frontend"
  frontend_ecr_image_url = "022499043310.dkr.ecr.ap-southeast-1.amazonaws.com/workshop-2/wineapp-frontend:v1.0.0"
  alb_dns_backend = module.aws_load_balance.alb_dns_backend
  frontend_target_group_blue_arn = module.aws_load_balance.frontend_target_group_blue_arn

  # Backend
  backend_log_group_name = "ecs/wine-website-backend-log-group"
  backend_container_name = "wine-website-backend"
  backend_ecr_image_url = "022499043310.dkr.ecr.ap-southeast-1.amazonaws.com/workshop-2/wineapp-backend:v1.0.0"
  mongodb_connection_string_secret_arn = module.database.mongodb_connection_string_arn
  backend_target_group_blue_arn = module.aws_load_balance.backend_target_group_blue_arn
}

module "aws_vpc" {
  source = "../../tf-modules/networking"
  
  vpc_name = "wine-website-vpc"

  vpc_cidr            = "10.0.0.0/16"
  vpc_azs             = ["ap-southeast-1a", "ap-southeast-1b"]
  
  vpc_public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  vpc_public_subnet_names = ["public-subnet-1-student-management", "public-subnet-2-student-management"]
  
  vpc_private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  vpc_private_subnet_names = ["private-subnet-1-student-management", "private-subnet-2-student-management"]
}

module "aws_security_group" {
  source = "../../tf-modules/security"

  vpc_id = module.aws_vpc.vpc_id
}

module "aws_load_balance" {
  source  = "../../tf-modules/load_balancer"

  load_balancer_name = "wine-website-load-balancer"
  
  vpc_id = module.aws_vpc.vpc_id
  
  load_balancer_security_group_ids = [
    module.aws_security_group.public_sg_id
  ] 
  
  load_balancer_subnets_ids = module.aws_vpc.public_subnet_ids
}

module "aws_iam" {
  source = "../../tf-modules/iam"
  
  task_execution_role_name = "wine-website-task-execution-role"
  task_execution_policy_name = "wine-website-task-execution-policy"
  
  task_role_name = "wine-website-task-role"
  task_role_policy_name = "wine-website-task-policy"
  
  codedeploy_service_role_name = "wine-website-codedeploy-service-role"
  codedeploy_service_policy_name = "wine-website-codedeploy-service-policy"
}

module "aws_bastion" {
  source = "../../tf-modules/bastion"

  instance_type = "t2.micro"
  ami_id = "ami-01938df366ac2d954"
  public_key_path = "../../Key/terraform.pub"

  vpc_security_group_ids = [
    module.aws_security_group.bastion_sg_id
  ]

  subnet_id = module.aws_vpc.public_subnet_ids[0]
}

module "database"{
  source = "../../tf-modules/database"
  db_username = "rootuser"
  db_subnet_group = module.aws_vpc.private_subnet_ids
  db_security_group_ids = [
    module.aws_security_group.database_sg_id
  ]
}

module "aws_code_deploy" {
  source = "../../tf-modules/code_deploy"

  codedeploy_app_name = "ecs-bluegreen-app"

  codedeploy_deployment_group_name_frontend = "ecs-bluegreen-deployment-group-frontend"
  codedeploy_deployment_group_name_backend = "ecs-bluegreen-deployment-group-backend"

  codedeploy_ecs_task_role_arn = module.aws_iam.codedeploy_service_role_arn

  codedeploy_ecs_cluster_name = module.aws_ecs_cluster.ecs_cluster_name

  codedeploy_ecs_service_frontend_name = module.aws_ecs_cluster.frontend_service_name
  codedeploy_ecs_service_backend_name = module.aws_ecs_cluster.backend_service_name

  codedeploy_frontend_listener_arn = module.aws_load_balance.frontend_listener_arn

  codedeploy_frontend_target_group_blue_name = module.aws_load_balance.frontend_target_group_blue_name
  codedeploy_frontend_target_group_green_name = module.aws_load_balance.frontend_target_group_green_name
  
  codedeploy_backend_target_group_blue_name = module.aws_load_balance.backend_target_group_blue_name
  codedeploy_backend_target_group_green_name = module.aws_load_balance.backend_target_group_green_name
}

