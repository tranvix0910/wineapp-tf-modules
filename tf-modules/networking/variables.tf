variable "vpc_cidr" {
  type        = string
  description = "The IPv4 CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  type        = list(string)
  description = "A list of availability zones names or ids in the region"
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "vpc_private_subnets" {
  type        = list(string)
  description = "A list of private subnets inside the VPC"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_public_subnets" {
  type        = list(string)
  description = "A list of public subnets inside the VPC"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "vpc_public_subnet_names" {
  type        = list(string)
  description = "Explicit values to use in the Name tag on public subnets"
  default     = ["wine-app-public-subnet-1", "wine-app-public-subnet-2"]
}

variable "vpc_private_subnet_names" {
  type        = list(string)
  description = "Explicit values to use in the Name tag on private subnets"
  default     = ["wine-app-private-subnet-1", "wine-app-private-subnet-2"]
}

variable "vpc_name" {
  type        = string
  description = "Name to be used on all the resources as identifier"
  default     = "wine-app-vpc"
}

variable "project_name" {
  type        = string
  description = "The name of the project"
  default     = "wine-app"
}
