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

variable "azs" {
  description = "Lista de Zonas de Disponibilidade a serem usadas."
  type        = list(string)
}

variable "vpc_cidr_main" {
  description = "CIDR da VPC Principal."
  type        = string
}

variable "vpc_cidr_secondary" {
  description = "CIDR da VPC Secundária."
  type        = string
}

variable "public_subnet_cidrs_main" {
  description = "Lista de CIDRs para sub-redes públicas na VPC Principal."
  type        = list(string)
}

variable "private_subnet_cidrs_main" {
  description = "Lista de CIDRs para sub-redes privadas na VPC Principal."
  type        = list(string)
}

variable "database_subnet_cidrs_main" {
  description = "Lista de CIDRs para sub-redes de banco de dados na VPC Principal."
  type        = list(string)
}

variable "private_subnet_cidrs_secondary" {
  description = "Lista de CIDRs para sub-redes privadas na VPC Secundária."
  type        = list(string)
}

