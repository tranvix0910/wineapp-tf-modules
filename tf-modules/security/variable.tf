variable "project_vpc_id" {
  type        = string
  description = "VPC ID for the project"
}

variable "project_name" {
  type        = string
  description = "The name of the project (e.g. wine-app)"
  default     = "wine-app"
}

variable "bastion_instance_name" {
  type        = string
  description = "Name for the bastion instance/SG"
  default     = "bastion"
}
