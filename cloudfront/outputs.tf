output "distribution_id" {
  description = "ID da distribuição CloudFront."
  value       = aws_cloudfront_distribution.static_content_cdn.id
}

output "distribution_domain_name" {
  description = "Nome de domínio da distribuição CloudFront."
  value       = aws_cloudfront_distribution.static_content_cdn.domain_name
}

output "cloudfront_arn" {
  description = "The arn of the Cloudfront"
  value = aws_cloudfront_distribution.static_content_cdn.arn
}
