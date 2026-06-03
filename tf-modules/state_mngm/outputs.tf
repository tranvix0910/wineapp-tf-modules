output "backend_config" {
  value = {
    bucket         = aws_s3_bucket.terraform_state.id
    dynamodb_table = aws_dynamodb_table.terraform_lock.name
    region         = aws_s3_bucket.terraform_state.region
    encrypt        = true
  }
  description = "Backend configuration values to use in other environments"
}

output "backend_config" {
  description = "Backend configuration snippet for other environments"
  value = <<-EOT
    terraform {
      backend "s3" {
        bucket         = "${aws_s3_bucket.terraform_state.id}"
        key            = "environments/dev/terraform.tfstate"
        region         = "${aws_s3_bucket.terraform_state.region}"
        dynamodb_table = "${aws_dynamodb_table.terraform_lock.name}"
        encrypt        = true
      }
    }
  EOT
}