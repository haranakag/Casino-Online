variable "project_name" {
  description = "Nome do projeto para nomenclatura de recursos."
  type        = string
}

variable "operation_name" {
  description = "Nome da operação para nomenclatura de recursos."
  type        = string
}

variable "s3_bucket_regional_domain_name" {
  description = "Nome de domínio regional do bucket S3."
  type        = string
}

variable "s3_origin_id" {
  description = "ID do Origin do S3 para o CloudFront."
  type        = string
}

variable "cloudfront_oac_id" {
  description = "ID do Origin Access Identity do CloudFront."
  type        = string
}

