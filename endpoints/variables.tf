variable "project_name" {
  description = "Nome do projeto para nomenclatura de recursos."
  type        = string
}

variable "operation_name" {
  description = "Nome da operação para nomenclatura de recursos."
  type        = string
}

variable "aws_region" {
  description = "Região da AWS onde a infraestrutura será implantada."
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC principal."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR da VPC principal."
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs das sub-redes privadas onde o endpoint de interface será criado."
  type        = list(string)
}

variable "private_route_table_ids" {
  description = "IDs das tabelas de roteamento privadas para associar o endpoint gateway."
  type        = list(string)
}

