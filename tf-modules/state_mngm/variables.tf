variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket to store Terraform state"
}


variable "enable_versioning" {
  type        = bool
  default     = true
  description = "Enable versioning on the S3 bucket to keep history of state files"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Allow destroying the S3 bucket even if it contains versioned objects. Set true for dev/test environments."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to all resources in this module"
}
