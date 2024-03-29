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

# Target group
resource "aws_lb_target_group" "tg" {
  name        = "my-tg"
  port        = 80
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

# Target group
resource "aws_lb_target_group" "tg-2" {
  name        = "my-tg-2"
  port        = 80
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
    Name        = "Target Group 2"
    Environment = "dev"
  }

}
# Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
  tags = {
    Name        = "Listener"
    Environment = "dev"
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
# 
resource "aws_route53_zone" "my_hosted_zone" {
  name = var.domain_name
}

resource "aws_acm_certificate" "my_certificate_request" {
  domain_name               = var.domain_name
  subject_alternative_names = [var.domain_name]
  validation_method         = "DNS"

  tags = {
    Name : var.domain_name
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_route53_record" "my_validation_record" {
  zone_id = aws_route53_zone.my_hosted_zone.zone_id
  name    = element(aws_acm_certificate.my_certificate_request.domain_validation_options[*].resource_record_name, 0)
  type    = element(aws_acm_certificate.my_certificate_request.domain_validation_options[*].resource_record_type, 0)
  records = [element(aws_acm_certificate.my_certificate_request.domain_validation_options[*].resource_record_value, 0)]
  ttl     = var.ttl
}

resource "aws_acm_certificate_validation" "my_certificate_validation" {
  certificate_arn         = aws_acm_certificate.my_certificate_request.arn
  validation_record_fqdns = [aws_route53_record.my_validation_record.fqdn]
}

resource "aws_route53_record" "my_caa_record" {
  zone_id = aws_route53_zone.my_hosted_zone.zone_id
  name    = var.domain_name
  type    = "CAA"
  records = [
    "0 issue \"amazon.com\"",
    "0 issuewild \"amazon.com\""
  ]
  ttl = var.ttl
}


resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate.my_certificate_request.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
