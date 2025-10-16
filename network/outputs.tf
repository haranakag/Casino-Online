output "main_vpc_id" {
  description = "ID da VPC Principal."
  value       = aws_vpc.main.id
}

output "secondary_vpc_id" {
  description = "ID da VPC Secundária."
  value       = aws_vpc.secondary.id
}

output "main_public_subnet_ids" {
  description = "IDs das sub-redes públicas da VPC Principal."
  value       = aws_subnet.main_public[*].id
}

output "main_private_subnet_ids" {
  description = "IDs das sub-redes privadas da VPC Principal."
  value       = aws_subnet.main_private[*].id
}

output "main_database_subnet_ids" {
  description = "IDs das sub-redes de banco de dados da VPC Principal."
  value       = aws_subnet.main_database[*].id
}

output "secondary_private_subnet_ids" {
  description = "IDs das sub-redes privadas da VPC Secundária."
  value       = aws_subnet.secondary_private[*].id
}

output "main_vpc_peering_connection_id" {
  description = "ID da conexão de peering entre as VPCs."
  value       = aws_vpc_peering_connection.main_to_secondary.id
}

output "main_nat_gateway_id" {
  description = "ID do NAT Gateway na VPC Principal."
  value       = aws_nat_gateway.main.id
}

output "main_public_route_table_id" {
  description = "ID da tabela de roteamento pública da VPC Principal."
  value       = aws_route_table.main_public.id
}

output "main_private_route_table_id" {
  description = "ID da tabela de roteamento privada da VPC Principal."
  value       = aws_route_table.main_private.id
}

output "secondary_private_route_table_id" {
  description = "ID da tabela de roteamento privada da VPC Secundária."
  value       = aws_route_table.secondary_private.id
}

