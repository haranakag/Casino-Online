output "main_vpc_id" {
  description = "ID da VPC Principal."
  value       = module.network.main_vpc_id
}

output "secondary_vpc_id" {
  description = "ID da VPC Secundária."
  value       = module.network.secondary_vpc_id
}

output "main_public_subnet_ids" {
  description = "IDs das sub-redes públicas da VPC Principal."
  value       = module.network.main_public_subnet_ids
}

output "main_private_subnet_ids" {
  description = "IDs das sub-redes privadas da VPC Principal."
  value       = module.network.main_private_subnet_ids
}

output "main_database_subnet_ids" {
  description = "IDs das sub-redes de banco de dados da VPC Principal."
  value       = module.network.main_database_subnet_ids
}

output "secondary_private_subnet_ids" {
  description = "IDs das sub-redes privadas da VPC Secundária."
  value       = module.network.secondary_private_subnet_ids
}

output "alb_dns_name" {
  description = "Nome DNS do Application Load Balancer."
  value       = module.instances.alb_dns_name
}

output "s3_static_content_bucket_id" {
  description = "ID do bucket S3 para conteúdo estático."
  value       = module.s3.static_content_bucket_id
}

output "cloudfront_distribution_domain_name" {
  description = "Nome de domínio da distribuição CloudFront."
  value       = module.cloudfront.distribution_domain_name
}

output "rds_endpoint" {
  description = "Endpoint do banco de dados RDS principal."
  value       = module.database.rds_endpoint
}

output "s3_gateway_endpoint_id" {
  description = "ID do VPC Endpoint Gateway para S3."
  value       = module.endpoints.s3_gateway_endpoint_id
}

output "secretsmanager_interface_endpoint_id" {
  description = "ID do VPC Endpoint Interface para Secrets Manager."
  value       = module.endpoints.secretsmanager_interface_endpoint_id
}

output "ec2_log_group_name" {
  description = "Nome do grupo de logs do CloudWatch para EC2."
  value       = module.monitoring.ec2_log_group_name
}

output "application_log_group_name" {
  description = "Nome do grupo de logs do CloudWatch para aplicações."
  value       = module.monitoring.application_log_group_name
}

output "alb_access_logs_bucket_id" {
  description = "ID do bucket S3 para logs de acesso do ALB."
  value       = module.monitoring.alb_access_logs_bucket_id
}

