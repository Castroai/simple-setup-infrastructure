# Load balancer security group
resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "Load Balancer Security Group"
    Environment = "dev"
  }

}

# Load balancer
resource "aws_lb" "lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.public_subnet_ids
  tags = {
    Name        = "Load Balancer"
    Environment = "dev"
  }
}
# API Target group
resource "aws_lb_target_group" "api-tg" {
  name        = "api-tg"
  port        = 443
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
  tags = {
    Name        = "Target Group"
    Environment = "dev"
  }

}

# API HTTPS Listener
resource "aws_lb_listener" "api_https_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api-tg.arn
  }
}
# Web HTTPS Listener
resource "aws_lb_listener" "client_https_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate_validation.example.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-tg.arn
  }
}

# Web Target group
resource "aws_lb_target_group" "web-tg" {
  name        = "web-tg"
  port        = 443
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
  tags = {
    Name        = "Target Group Web"
    Environment = "dev"
  }

}




# HTTP Redirect Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  tags = {
    Name        = "Listener"
    Environment = "dev"
  }
}


# Route 53 Record for Next.js service
resource "aws_route53_record" "nextjs_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "simplesetup.dev"
  type    = "A"
  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}


variable "domain_name" {
  description = "The domain name for the certificate"
  default     = "simplesetup.dev"
}

variable "ttl" {
  description = "The time to live for the record set"
  default     = 60
}

# Load Balancer Certificate
resource "aws_lb_listener_certificate" "example" {
  listener_arn    = aws_lb_listener.api_https_listener.arn
  certificate_arn = aws_acm_certificate.example.arn
}

# Route 53 Zone
resource "aws_route53_zone" "primary" {
  name = "simplesetup.dev"
}

# Route 53 Record for Domain Validation
resource "aws_route53_record" "example" {
  for_each = {
    for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.primary.zone_id
}

# ACM Certificate Validation
resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.example.arn
  validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
}

# Route 53 Record for API Subdomain
resource "aws_route53_record" "api_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "api.simplesetup.dev"
  type    = "A"
  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}

# ACM Certificate
resource "aws_acm_certificate" "example" {
  domain_name               = "simplesetup.dev"
  subject_alternative_names = ["api.simplesetup.dev"] # Add the API subdomain
  validation_method         = "DNS"
}

