
module "aws_ecs_cluster" {

  source = "../../tf-modules/ecs_cluster"

  ecs_region       = "ap-southeast-1"
  project_name     = var.project_name
  ecs_cluster_name = "${var.project_name}-ecs-cluster"

  ecs_subnet_ids = module.aws_vpc.private_subnet_ids
  ecs_security_group_ids = [
    module.aws_security_group.private_sg_id
  ]
  ecs_task_execution_role_arn = module.aws_iam.task_execution_role_arn
  ecs_task_role_arn           = module.aws_iam.task_role_arn

  # Backend
  backend_log_group_name               = "ecs/${var.project_name}-backend-log-group"
  backend_container_name               = "${var.project_name}-backend"
  backend_ecr_image_url                = var.backend_ecr_image_url
  mongodb_connection_string_secret_arn = module.aws_database.mongodb_connection_string_arn
  backend_target_group_blue_arn        = module.aws_load_balance.backend_target_group_blue_arn
}

module "aws_vpc" {
  source = "../../tf-modules/networking"

  vpc_name = "${var.project_name}-vpc"

  vpc_cidr = var.vpc_cidr
  vpc_azs  = var.vpc_azs

  vpc_public_subnets      = var.vpc_public_subnets
  vpc_public_subnet_names = var.vpc_public_subnet_names

  vpc_private_subnets      = var.vpc_private_subnets
  vpc_private_subnet_names = var.vpc_private_subnet_names
}

module "aws_security_group" {
  source = "../../tf-modules/security"

  project_name          = var.project_name
  project_vpc_id        = module.aws_vpc.vpc_id
  bastion_instance_name = "${var.project_name}-bastion"
}

module "aws_bastion_instance" {
  source = "../../tf-modules/bastion"

  bastion_instance_name = "${var.project_name}-bastion"
  instance_type         = var.instance_type
  ami_id                = var.ami_id

  vpc_security_group_ids = [module.aws_security_group.bastion_sg_id]
  public_subnet_id       = module.aws_vpc.public_subnet_ids[0]
}

module "aws_iam" {
  source = "../../tf-modules/iam"

  project_name                   = var.project_name
  environment                    = var.environment
  task_execution_role_name       = "${var.project_name}-task-execution-role"
  task_execution_policy_name     = "${var.project_name}-task-execution-policy"
  task_role_name                 = "${var.project_name}-task-role"
  task_role_policy_name          = "${var.project_name}-task-role-policy"
  codedeploy_service_role_name   = "${var.project_name}-codedeploy-service-role"
  codedeploy_service_policy_name = "${var.project_name}-codedeploy-service-policy"
  backend_build_role_name        = "${var.project_name}-backend-codebuild-role"
  backend_build_policy_name      = "${var.project_name}-backend-codebuild-policy"
  frontend_build_role_name       = "${var.project_name}-frontend-codebuild-role"
  frontend_build_policy_name     = "${var.project_name}-frontend-codebuild-policy"
}

module "aws_route53" {
  source = "../../tf-modules/route53"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  project_name = var.project_name
  domain_name  = var.domain_name
}

module "aws_load_balance" {
  source = "../../tf-modules/load_balancer"

  project_name = var.project_name
  vpc_id       = module.aws_vpc.vpc_id

  load_balancer_security_group_ids = [
    module.aws_security_group.public_sg_id
  ]
  load_balancer_subnets_ids = module.aws_vpc.public_subnet_ids
}

module "aws_s3_frontend" {
  source = "../../tf-modules/s3_frontend"

  project_name   = var.project_name
  environment    = var.environment
  cloudfront_arn = module.aws_cloudfront.cloudfront_arn
}

module "aws_cloudfront" {
  source = "../../tf-modules/cloudfront"

  project_name                   = var.project_name
  environment                    = var.environment
  domain_name                    = var.domain_name
  s3_bucket_regional_domain_name = module.aws_s3_frontend.bucket_regional_domain_name
  alb_dns_name                   = module.aws_load_balance.alb_dns_name
  acm_certificate_arn            = module.aws_route53.acm_certificate_arn
  route53_zone_id                = module.aws_route53.route53_zone_id
}

module "aws_database" {
  source = "../../tf-modules/database"

  project_name          = var.project_name
  db_username           = var.db_username
  db_subnet_group       = module.aws_vpc.private_subnet_ids
  db_security_group_ids = [module.aws_security_group.database_sg_id]
}

module "aws_code_deploy" {
  source = "../../tf-modules/code_deploy"

  project_name                             = var.project_name
  codedeploy_app_name                      = "ecs-bluegreen-app"
  codedeploy_deployment_group_name_backend = "ecs-bluegreen-deployment-group-backend"

  codedeploy_ecs_task_role_arn        = module.aws_iam.codedeploy_service_role_arn
  codedeploy_ecs_cluster_name         = module.aws_ecs_cluster.ecs_cluster_name
  codedeploy_ecs_service_backend_name = module.aws_ecs_cluster.backend_service_name

  codedeploy_listener_arn                    = module.aws_load_balance.listener_arn
  codedeploy_backend_target_group_blue_name  = module.aws_load_balance.backend_target_group_blue_name
  codedeploy_backend_target_group_green_name = module.aws_load_balance.backend_target_group_green_name
}

# module "aws_codecommit" {
#   source = "../../tf-modules/codecommit"
# 
#   project_name = var.project_name
# }
# 
# module "aws_codebuild" {
#   source = "../../tf-modules/codebuild"
# 
#   project_name = var.project_name
#   environment  = var.environment
# 
#   backend_ecr_repo_url        = split(":", var.backend_ecr_image_url)[0]
#   frontend_bucket_id          = module.aws_s3_frontend.bucket_id
#   frontend_bucket_arn         = module.aws_s3_frontend.bucket_arn
#   cloudfront_distribution_id  = module.aws_cloudfront.cloudfront_distribution_id
#   artifacts_bucket_arn        = module.aws_codepipeline.artifacts_bucket_arn
#   artifacts_bucket_id         = module.aws_codepipeline.artifacts_bucket_id
#   backend_build_role_arn      = module.aws_iam.backend_build_role_arn
#   frontend_build_role_arn     = module.aws_iam.frontend_build_role_arn
# }
# 
# module "aws_codepipeline" {
#   source = "../../tf-modules/codepipeline"
# 
#   project_name                     = var.project_name
#   environment                      = var.environment
#   backend_codecommit_repo_name     = module.aws_codecommit.backend_repository_name
#   backend_codecommit_repo_arn      = module.aws_codecommit.backend_repository_arn
#   frontend_codecommit_repo_name    = module.aws_codecommit.frontend_repository_name
#   frontend_codecommit_repo_arn     = module.aws_codecommit.frontend_repository_arn
#   backend_codebuild_project_name   = module.aws_codebuild.backend_project_name
#   frontend_codebuild_project_name  = module.aws_codebuild.frontend_project_name
#   codedeploy_app_name              = "${var.project_name}-ecs-bluegreen-app"
#   codedeploy_deployment_group_name = "${var.project_name}-ecs-bluegreen-deployment-group-backend"
# }
# 
# module "tf_state" {
#   source = "../../tf-modules/state_mngm"
# 
#   bucket_name = "${var.project_name}-${var.environment}-tf-state"
# }
