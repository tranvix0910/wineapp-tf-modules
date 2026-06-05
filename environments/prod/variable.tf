variable "project_name" {
  type        = string
  description = "The name of the project"
  default     = "wineapp"
}

variable "environment" {
  type        = string
  description = "The environment (e.g. dev, prod)"
  default     = "prod"
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "vpc_azs" {
  type    = list(string)
  default = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

variable "vpc_public_subnets" {
  type    = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "vpc_public_subnet_names" {
  type    = list(string)
  default = ["prod-public-subnet-1", "prod-public-subnet-2", "prod-public-subnet-3"]
}

variable "vpc_private_subnets" {
  type    = list(string)
  default = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]
}

variable "vpc_private_subnet_names" {
  type    = list(string)
  default = ["prod-private-subnet-1", "prod-private-subnet-2", "prod-private-subnet-3"]
}
