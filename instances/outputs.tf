output "alb_dns_name" {
  description = "Nome DNS do Application Load Balancer."
  value       = aws_lb.application_lb.dns_name
}

output "alb_arn" {
  description = "ARN do Application Load Balancer."
  value       = aws_lb.application_lb.arn
}

output "ec2_instance_ids" {
  description = "IDs das instâncias EC2."
  value       = {
    frontsite  = aws_instance.frontsite[*].id
    backoffice = aws_instance.backoffice[*].id
    webapi     = aws_instance.webapi[*].id
    gameapi    = aws_instance.gameapi[*].id
  }
}

output "ec2_security_group_id" {
  description = "ID do Security Group das instâncias EC2."
  value       = aws_security_group.ec2.id
}

