output "acm_certificate_arn" {
  description = "The ARN of the validated ACM certificate"
  value       = aws_acm_certificate_validation.project_cert_validation.certificate_arn
}

output "route53_zone_id" {
  description = "The ID of the hosted zone of the ALB"
  value       = data.aws_route53_zone.public_zone.zone_id
}