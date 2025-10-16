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

variable "public_subnet_ids" {
  description = "IDs das sub-redes públicas para o ALB."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "IDs das sub-redes privadas para as instâncias EC2."
  type        = list(string)
}

variable "alb_certificate_arn" {
  description = "ARN do certificado ACM para o ALB."
  type        = string
}

variable "ami_id" {
  description = "ID da AMI para as instâncias EC2."
  type        = string
}

variable "ec2_instance_type" {
  description = "Tipo de instância EC2 para as aplicações."
  type        = string
}

