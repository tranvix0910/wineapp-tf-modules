module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets
  public_subnet_names = var.vpc_public_subnet_names
  private_subnet_names = var.vpc_private_subnet_names

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false
}

# Create subnet group for MongoDB
# resource "aws_docdb_subnet_group" "mongodb_subnet_group" {
#   subnet_ids = module.vpc.private_subnets
#   name       = "mongodb-subnet-group"
# }