variable "project_name" {
  type        = string
  description = "The name of the project"
  default     = "wine-app"
}

variable "environment" {
  type        = string
  description = "The environment (e.g. dev, prod)"
  default     = "dev"
}

variable "backend_ecr_image_url" {
  type        = string
  description = "The ECR image URL for the backend"
  default     = "022499043310.dkr.ecr.ap-southeast-1.amazonaws.com/workshop-2/wineapp-backend:v1.0.0"
}

variable "domain_name" {
  type        = string
  description = "The root domain name"
  default     = "wineapp.click"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_azs" {
  type    = list(string)
  default = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "vpc_public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_public_subnet_names" {
  type    = list(string)
  default = ["public-subnet-1", "public-subnet-2"]
}

variable "vpc_private_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "vpc_private_subnet_names" {
  type    = list(string)
  default = ["private-subnet-1", "private-subnet-2"]
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_id" {
  type    = string
  default = "ami-01938df366ac2d954"
}

variable "db_username" {
  type    = string
  default = "dbadmin"
}
