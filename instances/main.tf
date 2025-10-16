resource "aws_lb" "application_lb" {
  name               = "${var.project_name}-${var.operation_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "${var.project_name}-${var.operation_name}-alb"
    Project = var.project_name
    Operation = var.operation_name
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.alb_certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontsite.arn
  }
}

resource "aws_lb_target_group" "frontsite" {
  name     = "${var.project_name}-${var.operation_name}-frontsite-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.project_name}-${var.operation_name}-frontsite-tg"
    Project = var.project_name
    Operation = var.operation_name
  }
}

resource "aws_lb_target_group" "backoffice" {
  name     = "${var.project_name}-${var.operation_name}-backoffice-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.project_name}-${var.operation_name}-backoffice-tg"
    Project = var.project_name
    Operation = var.operation_name
  }
}

resource "aws_lb_target_group" "webapi" {
  name     = "${var.project_name}-${var.operation_name}-webapi-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.project_name}-${var.operation_name}-webapi-tg"
    Project = var.project_name
    Operation = var.operation_name
  }
}

resource "aws_lb_target_group" "gameapi" {
  name     = "${var.project_name}-${var.operation_name}-gameapi-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.project_name}-${var.operation_name}-gameapi-tg"
    Project = var.project_name
    Operation = var.operation_name
  }
}

# Security Group para o ALB
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.operation_name}-alb-sg"
  description = "Permite tráfego HTTPS vindo APENAS do CloudFront"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow HTTPS from CloudFront"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = [data.aws_prefix_list.cloudfront.id]
  }

  ingress {
    description     = "Allow HTTP from CloudFront for redirect"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    prefix_list_ids = [data.aws_prefix_list.cloudfront.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.operation_name}-alb-sg"
    Project = var.project_name
    Operation = var.operation_name
  }
}

# Redirects HTTP to HTTPS
resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Security Group para as instâncias EC2
resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-${var.operation_name}-ec2-sg"
  description = "Permite tráfego do ALB para as instâncias EC2"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.operation_name}-ec2-sg"
    Project = var.project_name
    Operation = var.operation_name
  }
}

# Instâncias EC2 para frontsite
resource "aws_instance" "frontsite" {
  count         = length(var.private_subnet_ids)
  ami           = var.ami_id
  instance_type = var.ec2_instance_type
  subnet_id     = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [aws_security_group.ec2.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from frontsite instance ${count.index + 1}" > /var/www/html/index.html
              sudo systemctl start httpd || sudo apt-get install -y apache2 && sudo systemctl start apache2
              EOF

  tags = {
    Name = "${var.project_name}-${var.operation_name}-frontsite-${count.index + 1}-${var.aws_region}"
    Project = var.project_name
    Operation = var.operation_name
  }
}

resource "aws_lb_target_group_attachment" "frontsite" {
  count            = length(aws_instance.frontsite)
  target_group_arn = aws_lb_target_group.frontsite.arn
  target_id        = aws_instance.frontsite[count.index].id
  port             = 80
}

# Instâncias EC2 para backoffice
resource "aws_instance" "backoffice" {
  count         = length(var.private_subnet_ids)
  ami           = var.ami_id
  instance_type = var.ec2_instance_type
  subnet_id     = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [aws_security_group.ec2.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from backoffice instance ${count.index + 1}" > /var/www/html/index.html
              sudo systemctl start httpd || sudo apt-get install -y apache2 && sudo systemctl start apache2
              EOF

  tags = {
    Name = "${var.project_name}-${var.operation_name}-backoffice-${count.index + 1}-${var.aws_region}"
    Project = var.project_name
    Operation = var.operation_name
  }
}

resource "aws_lb_target_group_attachment" "backoffice" {
  count            = length(aws_instance.backoffice)
  target_group_arn = aws_lb_target_group.backoffice.arn
  target_id        = aws_instance.backoffice[count.index].id
  port             = 80
}

# Instâncias EC2 para webapi
resource "aws_instance" "webapi" {
  count         = length(var.private_subnet_ids)
  ami           = var.ami_id
  instance_type = var.ec2_instance_type
  subnet_id     = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [aws_security_group.ec2.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from webapi instance ${count.index + 1}" > /var/www/html/index.html
              sudo systemctl start httpd || sudo apt-get install -y apache2 && sudo systemctl start apache2
              EOF

  tags = {
    Name = "${var.project_name}-${var.operation_name}-webapi-${count.index + 1}-${var.aws_region}"
    Project = var.project_name
    Operation = var.operation_name
  }
}

resource "aws_lb_target_group_attachment" "webapi" {
  count            = length(aws_instance.webapi)
  target_group_arn = aws_lb_target_group.webapi.arn
  target_id        = aws_instance.webapi[count.index].id
  port             = 80
}

# Instâncias EC2 para gameapi
resource "aws_instance" "gameapi" {
  count         = length(var.private_subnet_ids)
  ami           = var.ami_id
  instance_type = var.ec2_instance_type
  subnet_id     = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [aws_security_group.ec2.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from gameapi instance ${count.index + 1}" > /var/www/html/index.html
              sudo systemctl start httpd || sudo apt-get install -y apache2 && sudo systemctl start apache2
              EOF

  tags = {
    Name = "${var.project_name}-${var.operation_name}-gameapi-${count.index + 1}-${var.aws_region}"
    Project = var.project_name
    Operation = var.operation_name
  }
}

resource "aws_lb_target_group_attachment" "gameapi" {
  count            = length(aws_instance.gameapi)
  target_group_arn = aws_lb_target_group.gameapi.arn
  target_id        = aws_instance.gameapi[count.index].id
  port             = 80
}

data "aws_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}
