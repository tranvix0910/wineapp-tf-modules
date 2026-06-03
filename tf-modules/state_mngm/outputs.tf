output "backend_config" {
  value = {
    bucket       = aws_s3_bucket.terraform_state.id
    region       = aws_s3_bucket.terraform_state.region
    encrypt      = true
    use_lockfile = true
  }
  description = "Backend configuration values to use in other environments"
}

output "backend_config_snippet" {
  description = "Backend configuration snippet for other environments"
  value = <<-EOT
    terraform {
      backend "s3" {
        bucket       = "${aws_s3_bucket.terraform_state.id}"
        key          = "environments/dev/terraform.tfstate"
        region       = "${aws_s3_bucket.terraform_state.region}"
        encrypt      = true
        use_lockfile = true
      }
    }
  EOT
}