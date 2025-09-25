module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name           = "bastion-key"
  public_key = file(var.public_key_path)
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "bastion-host"

  instance_type          = var.instance_type
  key_name               = module.key_pair.key_pair_name
  ami                    = var.ami_id
  monitoring             = true
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id              = var.subnet_id
  associate_public_ip_address = true
  user_data = file("${path.module}/install-mongodb-client.sh")
}