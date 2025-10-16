output "static_content_bucket_id" {
  description = "ID do bucket S3 para conteúdo estático."
  value       = aws_s3_bucket.static_content.id
}

output "static_content_bucket_arn" {
  description = "ARN do bucket S3 para conteúdo estático."
  value       = aws_s3_bucket.static_content.arn
}

output "cloudfront_oac_id" {
  description = "ID do Origin Access Control do CloudFront."
  value       = aws_cloudfront_origin_access_control.static_content_oac.id
}
