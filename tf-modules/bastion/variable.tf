variable "bastion_instance_name" {
  type        = string
  description = "Name of the bastion host"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "List of security group IDs for the bastion host"
}

variable "public_subnet_id" {
  type        = string
  description = "Public Subnet ID for the bastion host"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the bastion host"
}

variable "instance_type" {
  type        = string
  description = "Instance type for the bastion host"
}
