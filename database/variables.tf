variable "project_name" {
  description = "Nome do projeto para nomenclatura de recursos."
  type        = string
}

variable "operation_name" {
  description = "Nome da operação para nomenclatura de recursos."
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC principal."
  type        = string
}

variable "database_subnet_ids" {
  description = "IDs das sub-redes de banco de dados."
  type        = list(string)
}

variable "db_allocated_storage" {
  description = "Tamanho do armazenamento alocado para o banco de dados principal (GB)."
  type        = number
}

variable "db_engine" {
  description = "Motor do banco de dados principal."
  type        = string
}

variable "db_engine_version" {
  description = "Versão do motor do banco de dados principal."
  type        = string
}

variable "db_instance_type" {
  description = "Tipo de instância RDS para o banco de dados principal."
  type        = string
}

variable "db_username" {
  description = "Nome de usuário mestre para o banco de dados principal."
  type        = string
}

variable "db_password" {
  description = "Senha mestre para o banco de dados principal."
  type        = string
  sensitive   = true
}

variable "ec2_security_group_id" {
  description = "ID do Security Group das instâncias EC2 para permitir acesso ao RDS."
  type        = string
}

