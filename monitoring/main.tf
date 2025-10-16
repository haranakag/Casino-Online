resource "aws_cloudwatch_log_group" "ec2_logs" {
  name              = "/${var.project_name}/${var.operation_name}/ec2"
  retention_in_days = 30

  tags = {
    Name = "${var.project_name}-${var.operation_name}-ec2-log-group"
    Project = var.project_name
    Operation = var.operation_name
  }
}

resource "aws_cloudwatch_log_group" "application_logs" {
  name              = "/${var.project_name}/${var.operation_name}/applications"
  retention_in_days = 30

  tags = {
    Name = "${var.project_name}-${var.operation_name}-app-log-group"
    Project = var.project_name
    Operation = var.operation_name
  }
}

resource "aws_s3_bucket" "alb_access_logs" {
  bucket = var.log_bucket_name

  tags = {
    Name = "${var.project_name}-${var.operation_name}-alb-access-logs"
    Project = var.project_name
    Operation = var.operation_name
  }
}

resource "aws_s3_bucket_acl" "alb_access_logs_acl" {
  bucket = aws_s3_bucket.alb_access_logs.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_policy" "alb_access_logs_policy" {
  bucket = aws_s3_bucket.alb_access_logs.id
  policy = data.aws_iam_policy_document.alb_log_delivery.json
}

data "aws_iam_policy_document" "alb_log_delivery" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.alb_access_logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_elb_service_account.current.id}:root"]
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_elb_service_account" "current" {}

output "ec2_log_group_name" {
  description = "Nome do grupo de logs do CloudWatch para EC2."
  value       = aws_cloudwatch_log_group.ec2_logs.name
}

output "application_log_group_name" {
  description = "Nome do grupo de logs do CloudWatch para aplicações."
  value       = aws_cloudwatch_log_group.application_logs.name
}

output "alb_access_logs_bucket_id" {
  description = "ID do bucket S3 para logs de acesso do ALB."
  value       = aws_s3_bucket.alb_access_logs.id
}

