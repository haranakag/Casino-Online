output "main_vpc_id" {
  description = "ID de VPC Principal."
  value       = module.network.main_vpc_id
}

output "secondary_vpc_id" {
  description = "ID de VPC Secundaria."
  value       = module.network.secondary_vpc_id
}

output "main_public_subnet_ids" {
  description = "ID de subred pública de VPC principal."
  value       = module.network.main_public_subnet_ids
}

output "main_private_subnet_ids" {
  description = "ID de subred privada de VPC principal."
  value       = module.network.main_private_subnet_ids
}

output "main_database_subnet_ids" {
  description = "ID de subred de base de datos de VPC principal."
  value       = module.network.main_database_subnet_ids
}

output "secondary_private_subnet_ids" {
  description = "ID de subred privada de VPC secundaria."
  value       = module.network.secondary_private_subnet_ids
}

output "alb_dns_name" {
  description = "Nombre DNS del balanceador de carga de aplicaciones."
  value       = module.instances.alb_dns_name
}

output "s3_static_content_bucket_id" {
  description = "ID de depósito S3 para contenido estático."
  value       = module.s3.static_content_bucket_id
}

output "cloudfront_distribution_domain_name" {
  description = "Nombre de dominio de distribución de CloudFront."
  value       = module.cloudfront.distribution_domain_name
}

output "rds_endpoint" {
  description = "Endpoint de la base de datos RDS principal."
  value       = module.database.rds_endpoint
}

output "s3_gateway_endpoint_id" {
  description = "ID de VPC Endpoint Gateway para S3."
  value       = module.endpoints.s3_gateway_endpoint_id
}

output "secretsmanager_interface_endpoint_id" {
  description = "ID de VPC Endpoint Interface para Secrets Manager."
  value       = module.endpoints.secretsmanager_interface_endpoint_id
}

output "ec2_log_group_name" {
  description = "Nombre del grupo de registros de CloudWatch para EC2."
  value       = module.monitoring.ec2_log_group_name
}

output "application_log_group_name" {
  description = "Nombre del grupo de registros de CloudWatch para aplicaciones."
  value       = module.monitoring.application_log_group_name
}

output "alb_access_logs_bucket_id" {
  description = "ID de depósito S3 para registros de acceso de ALB."
  value       = module.monitoring.alb_access_logs_bucket_id
}

