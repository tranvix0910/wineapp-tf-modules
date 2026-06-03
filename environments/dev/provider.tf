terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.37.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

# terraform {
#   backend "s3" {
#     bucket       = "vib-wineapp-terraform-state"
#     key          = "environments/dev/terraform.tfstate"
#     region       = "ap-southeast-1"
#     encrypt      = true
#     use_lockfile = true
#   }
# }

# aws secretsmanager delete-secret --secret-id wineapp-mongodb-password --force-delete-without-recovery
# aws secretsmanager delete-secret --secret-id wineapp-mongodb-connection-string --force-delete-without-recovery