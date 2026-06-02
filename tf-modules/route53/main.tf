terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.us_east_1]
    }
  }
}

data "aws_route53_zone" "public_zone" {
  name         = var.domain_name
  private_zone = false // Public Hosted Zone
}

# Certificate for CloudFront (Must be in us-east-1)
resource "aws_acm_certificate" "project_cert" {
  provider                  = aws.us_east_1
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "project_cert_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.project_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.public_zone.zone_id
}

resource "aws_acm_certificate_validation" "project_cert_validation" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.project_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.project_cert_validation_record : record.fqdn]
}


