resource "aws_iam_role" "ssm_role" {
  name               = "${var.bastion_instance_name}-ssm-role"
  assume_role_policy = file("${path.module}/ec2_assume_role_policy.json")
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${var.bastion_instance_name}-ssm-profile"
  role = aws_iam_role.ssm_role.name
}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = var.bastion_instance_name

  instance_type          = var.instance_type
  ami                    = var.ami_id
  vpc_security_group_ids = var.vpc_security_group_ids

  // Auto detect VPC
  subnet_id = var.public_subnet_id

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  user_data = file("${path.module}/scripts/install-mongodb-client.sh")
}