resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = var.private_route_table_ids

  tags = {
    Name = "${var.project_name}-${var.operation_name}-s3-gateway-endpoint"
    Project = var.project_name
    Operation = var.operation_name
  }
}

resource "aws_vpc_endpoint" "secretsmanager_interface" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.secretsmanager"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids
  security_group_ids = [aws_security_group.secretsmanager_endpoint.id]
  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-${var.operation_name}-secretsmanager-interface-endpoint"
    Project = var.project_name
    Operation = var.operation_name
  }
}

resource "aws_security_group" "secretsmanager_endpoint" {
  name        = "${var.project_name}-${var.operation_name}-secretsmanager-endpoint-sg"
  description = "Permite tráfego para o VPC Endpoint do Secrets Manager"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.operation_name}-secretsmanager-endpoint-sg"
    Project = var.project_name
    Operation = var.operation_name
  }
}

output "s3_gateway_endpoint_id" {
  description = "ID do VPC Endpoint Gateway para S3."
  value       = aws_vpc_endpoint.s3_gateway.id
}

output "secretsmanager_interface_endpoint_id" {
  description = "ID do VPC Endpoint Interface para Secrets Manager."
  value       = aws_vpc_endpoint.secretsmanager_interface.id
}

