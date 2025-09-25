variable "vpc_security_group_ids" {
  type = list(string)
}

variable "subnet_id" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "public_key_path" {
  type = string 
}

variable "instance_type" {
  type = string
}
