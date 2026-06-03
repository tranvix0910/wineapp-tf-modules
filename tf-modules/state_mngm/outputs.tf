output "backend_config" {
  value = {
    bucket         = aws_s3_bucket.terraform_state.id
    dynamodb_table = aws_dynamodb_table.terraform_lock.name
    region         = aws_s3_bucket.terraform_state.region
    encrypt        = true
  }
  description = "Backend configuration values to use in other environments"
}