resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "ALB ingress 80/443"
  vpc_id      = var.vpc_id
  ingress { 
    from_port = 80  
    to_port = 80  
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
    }
  ingress { 
    from_port = 443 
    to_port = 443 
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
    }
  egress  { 
    from_port = 0   
    to_port = 0   
    protocol = "-1"  
    cidr_blocks = ["0.0.0.0/0"] 
    }
}

resource "aws_lb" "this" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_target_group" "tg" {
  name        = "app-tg"
  vpc_id      = var.vpc_id
  port        = var.port
  protocol    = "HTTP"
  target_type = "ip"
  health_check { 
    path = "/" 
    }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port = 80
  protocol = "HTTP"
  default_action { 
    type = "redirect" 
    redirect { 
        port = "443" 
        protocol = "HTTPS" 
        status_code = "HTTP_301" 
        } 
    }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port = 443
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn = var.certificate_arn
  default_action { 
    type = "forward" 
    target_group_arn = aws_lb_target_group.tg.arn 
    }
}