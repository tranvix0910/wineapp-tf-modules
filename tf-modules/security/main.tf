module "public_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.project_name}-alb-sg"
  description = "Security group for public access"
  vpc_id      = var.project_vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules = ["all-all"]
}

module "bastion_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.project_name}-${var.bastion_instance_name}-sg"
  description = "Security group for Bastion"
  vpc_id      = var.project_vpc_id

  ingress_with_cidr_blocks = []
  egress_rules = ["all-all"]
}

module "private_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.project_name}-ecs-sg"
  description = "Security group for private access"
  vpc_id      = var.project_vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      source_security_group_id = module.public_sg.security_group_id
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      source_security_group_id = module.public_sg.security_group_id
    },
    {
      from_port   = 4000
      to_port     = 4000
      protocol    = "tcp"
      source_security_group_id = module.public_sg.security_group_id
    }
  ]
  egress_rules = ["all-all"]
}

module "database_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.project_name}-db-sg"
  description = "Security group for database MongoDB"
  vpc_id      = var.project_vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port   = 27017
      to_port     = 27017
      protocol    = "tcp"
      source_security_group_id = module.bastion_sg.security_group_id
    },
    {
      from_port   = 27017
      to_port     = 27017
      protocol    = "tcp"
      source_security_group_id = module.private_sg.security_group_id
    }
  ]
  egress_rules = ["all-all"]
}
