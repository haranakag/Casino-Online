variable "aws_region" {
  description = "Região da AWS onde a infraestrutura será implantada."
  type        = string
  default     = "ca-central-1"
}

variable "project_name" {
  description = "Nome do projeto para nomenclatura de recursos."
  type        = string
  default     = "cassino"
}

variable "operation_name" {
  description = "Nome da operação para nomenclatura de recursos."
  type        = string
  default     = "online"
}

variable "azs" {
  description = "Lista de Zonas de Disponibilidade a serem usadas."
  type        = list(string)
  default     = ["ca-central-1a", "ca-central-1b"]
}

variable "vpc_cidr_main" {
  description = "CIDR da VPC Principal."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_cidr_secondary" {
  description = "CIDR da VPC Secundária."
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidrs_main" {
  description = "Lista de CIDRs para sub-redes públicas na VPC Principal."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs_main" {
  description = "Lista de CIDRs para sub-redes privadas na VPC Principal."
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "database_subnet_cidrs_main" {
  description = "Lista de CIDRs para sub-redes de banco de dados na VPC Principal."
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "private_subnet_cidrs_secondary" {
  description = "Lista de CIDRs para sub-redes privadas na VPC Secundária."
  type        = list(string)
  default     = ["10.1.10.0/24", "10.1.11.0/24"]
}

variable "alb_certificate_arn" {
  description = "ARN do certificado ACM para o ALB."
  type        = string
  # Este valor deve ser preenchido com um ARN de certificado válido.
  # Exemplo: "arn:aws:acm:ca-central-1:123456789012:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  default = ""
}

variable "ec2_instance_type" {
  description = "Tipo de instância EC2 para as aplicações."
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "ID da AMI para as instâncias EC2."
  type        = string
  # Você precisará encontrar uma AMI adequada para ca-central-1, por exemplo, uma AMI do Amazon Linux 2.
  # Exemplo: "ami-0abcdef1234567890"
  default = "ami-0b135114708752253" # Amazon Linux 2 AMI (HVM) - SSD Volume Type (ca-central-1)
}

variable "db_instance_type" {
  description = "Tipo de instância RDS para o banco de dados principal."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Tamanho do armazenamento alocado para o banco de dados principal (GB)."
  type        = number
  default     = 20
}

variable "db_engine" {
  description = "Motor do banco de dados principal."
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Versão do motor do banco de dados principal."
  type        = string
  default     = "8.0.28"
}

variable "db_username" {
  description = "Nome de usuário mestre para o banco de dados principal."
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Senha mestre para o banco de dados principal."
  type        = string
  sensitive   = true
}

variable "redis_instance_type" {
  description = "Tipo de instância para o ElastiCache Redis."
  type        = string
  default     = "cache.t3.micro"
}

variable "s3_bucket_name" {
  description = "Nome do bucket S3 para conteúdo estático."
  type        = string
}

variable "log_bucket_name" {
  description = "Nome do bucket S3 para logs de acesso do ALB."
  type        = string
}

variable "redshift_node_type" {
  description = "Tipo de nó para o Redshift (se usado na VPC secundária)."
  type        = string
  default     = "dc2.large"
}

variable "redshift_cluster_type" {
  description = "Tipo de cluster para o Redshift (se usado na VPC secundária)."
  type        = string
  default     = "single-node"
}

variable "redshift_master_username" {
  description = "Nome de usuário mestre para o Redshift."
  type        = string
  default     = "redshiftadmin"
}

variable "redshift_master_password" {
  description = "Senha mestre para o Redshift."
  type        = string
  sensitive   = true
}

