module "aws_vpc" {
  source = "../../tf-modules/networking"

  vpc_name = "${var.project_name}-${var.environment}-vpc"

  vpc_cidr = var.vpc_cidr
  vpc_azs  = var.vpc_azs

  vpc_public_subnets      = var.vpc_public_subnets
  vpc_public_subnet_names = var.vpc_public_subnet_names

  vpc_private_subnets      = var.vpc_private_subnets
  vpc_private_subnet_names = var.vpc_private_subnet_names
}
