variable "project_name" {
  type        = string
  description = "The name of the project"
  default     = "wine-app"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_subnet_group" {
  description = "The subnets for the database"
  type        = list(string)
}

variable "db_security_group_ids" {
  description = "The security groups for the database"
  type        = list(string)
}
