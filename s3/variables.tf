variable "project_name" {
  description = "Nome do projeto para nomenclatura de recursos."
  type        = string
}

variable "operation_name" {
  description = "Nome da operação para nomenclatura de recursos."
  type        = string
}

variable "s3_bucket_name" {
  description = "Nome do bucket S3 para conteúdo estático."
  type        = string
}

variable "cloudfront_arn" {
  description = "The ARN of the CloudFront distribution. Used to restrict S3 bucket access via OAC policy."
  type        = string
}