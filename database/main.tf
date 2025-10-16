resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.operation_name}-db-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = {
    Name = "${var.project_name}-${var.operation_name}-db-subnet-group"
    Project = var.project_name
    Operation = var.operation_name
  }
}

resource "aws_db_instance" "main" {
  allocated_storage    = var.db_allocated_storage
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_type
  identifier           = "${var.project_name}-${var.operation_name}-db"
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot  = true
  multi_az             = true

  tags = {
    Name = "${var.project_name}-${var.operation_name}-db"
    Project = var.project_name
    Operation = var.operation_name
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.operation_name}-rds-sg"
  description = "Permite tráfego das instâncias EC2 para o RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306 # Porta padrão para MySQL, ajustar conforme o DB engine
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ec2_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.operation_name}-rds-sg"
    Project = var.project_name
    Operation = var.operation_name
  }
}

output "rds_endpoint" {
  description = "Endpoint do banco de dados RDS."
  value       = aws_db_instance.main.address
}

output "rds_port" {
  description = "Porta do banco de dados RDS."
  value       = aws_db_instance.main.port
}

output "rds_security_group_id" {
  description = "ID do Security Group do RDS."
  value       = aws_security_group.rds.id
}

