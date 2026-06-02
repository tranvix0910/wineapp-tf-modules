module "project_alb" {
  source  = "terraform-aws-modules/alb/aws"

  name               = "${var.project_name}-alb"

  vpc_id             = var.vpc_id
  subnets            = var.load_balancer_subnets_ids
  security_groups    = var.load_balancer_security_group_ids

  enable_deletion_protection = false

  # Listeners
  listeners = {
    https-443 = {
      port     = 443
      protocol = "HTTPS"
      certificate_arn = var.acm_certificate_arn
      forward = {
        target_group_key = "backend_blue"
      }
    }
    http-80 = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  # Target Groups for Blue/Green
  target_groups = {
    backend_blue = {
      name_prefix       = "blue-"
      backend_protocol  = "HTTP"
      backend_port      = 4000
      target_type       = "ip"
      create_attachment = false
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/health"
        port                = "traffic-port"
        healthy_threshold   = 2
        unhealthy_threshold = 3
        timeout             = 5
        protocol            = "HTTP"
      }
    }
    backend_green = {
      name_prefix       = "green-"
      backend_protocol  = "HTTP"
      backend_port      = 4000
      target_type       = "ip"
      create_attachment = false
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/health"
        port                = "traffic-port"
        healthy_threshold   = 2
        unhealthy_threshold = 3
        timeout             = 5
        protocol            = "HTTP"
      }
    }
  }
}

resource "aws_route53_record" "project_domain_alias_record" {
  zone_id = var.route53_zone_id
  name    = "${var.project_name}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = module.project_alb.dns_name
    zone_id                = module.project_alb.zone_id
    evaluate_target_health = true
  }
}