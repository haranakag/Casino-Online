variable "project_name" {
  description = "Nome do projeto para nomenclatura de recursos."
  type        = string
}

variable "operation_name" {
  description = "Nome da operação para nomenclatura de recursos."
  type        = string
}

variable "log_bucket_name" {
  description = "Nome do bucket S3 para logs de acesso do ALB."
  type        = string
}

