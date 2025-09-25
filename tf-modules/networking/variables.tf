variable "vpc_cidr" {
  type = string
}

variable "vpc_azs" {
  type = list(string)
}

variable "vpc_private_subnets" {
  type = list(string)
}   

variable "vpc_public_subnets" {
  type = list(string)
}

variable "vpc_public_subnet_names" {
  type = list(string)
}

variable "vpc_private_subnet_names" {
  type = list(string)
}

variable "vpc_name" {
  type = string
}

