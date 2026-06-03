terraform {
  backend "s3" {
    bucket       = "vib-wineapp-terraform-state"
    key          = "environments/dev/terraform.tfstate"
    region       = "ap-southeast-1"
    encrypt      = true
    use_lockfile = true
  }
}