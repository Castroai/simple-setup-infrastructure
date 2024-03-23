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


# 
