# Application Load Balancer
resource "aws_lb" "load_balancer" {
  name               = var.load_balancer_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.load_balancer_security_group_ids
  subnets            = var.load_balancer_subnets_ids
  enable_deletion_protection = false
  enable_http2               = true
  idle_timeout               = 60
  enable_cross_zone_load_balancing = true
}

# Frontend Load Balancer Listener
resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_target_group_blue.arn
  }
}

# Custom rule for backend API (/api/*)
resource "aws_lb_listener_rule" "backend_api_rule" {
  listener_arn = aws_lb_listener.frontend_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_target_group_blue.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}

# Frontend Target Group - Blue
resource "aws_lb_target_group" "frontend_target_group_blue" {
  name        = "frontend-target-group-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "80"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }
}

# Frontend Target Group - 
resource "aws_lb_target_group" "frontend_target_group_green" {
  name        = "frontend-target-group-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "80"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }
}

# Backend Target Group
resource "aws_lb_target_group" "backend_target_group_blue" {
  name        = "backend-target-group-blue"
  port        = 4000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/health"
    protocol            = "HTTP"
    port                = "4000"  
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }
}

# Backend Target Group - Green
resource "aws_lb_target_group" "backend_target_group_green" {
  name        = "backend-target-group-green"
  port        = 4000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/health"
    protocol            = "HTTP"
    port                = "4000"  
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }
}

