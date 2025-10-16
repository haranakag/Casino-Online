provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./network"

  project_name                   = var.project_name
  operation_name                 = var.operation_name
  aws_region                     = var.aws_region
  azs                            = var.azs
  vpc_cidr_main                  = var.vpc_cidr_main
  vpc_cidr_secondary             = var.vpc_cidr_secondary
  public_subnet_cidrs_main       = var.public_subnet_cidrs_main
  private_subnet_cidrs_main      = var.private_subnet_cidrs_main
  database_subnet_cidrs_main     = var.database_subnet_cidrs_main
  private_subnet_cidrs_secondary = var.private_subnet_cidrs_secondary
}

module "instances" {
  source = "./instances"

  project_name        = var.project_name
  operation_name      = var.operation_name
  aws_region          = var.aws_region
  vpc_id              = module.network.main_vpc_id
  public_subnet_ids   = module.network.main_public_subnet_ids
  private_subnet_ids  = module.network.main_private_subnet_ids
  alb_certificate_arn = var.alb_certificate_arn
  ami_id              = var.ami_id
  ec2_instance_type   = var.ec2_instance_type
}

module "s3" {
  source = "./s3"

  cloudfront_arn = module.cloudfront.cloudfront_arn
  project_name   = var.project_name
  operation_name = var.operation_name
  s3_bucket_name = var.s3_bucket_name
}

module "cloudfront" {
  source = "./cloudfront"

  project_name                   = var.project_name
  operation_name                 = var.operation_name
  s3_bucket_regional_domain_name = module.s3.static_content_bucket_id
  s3_origin_id                   = module.s3.static_content_bucket_id
  cloudfront_oac_id              = module.s3.cloudfront_oac_id
}

module "database" {
  source = "./database"

  project_name          = var.project_name
  operation_name        = var.operation_name
  vpc_id                = module.network.main_vpc_id
  database_subnet_ids   = module.network.main_database_subnet_ids
  db_allocated_storage  = var.db_allocated_storage
  db_engine             = var.db_engine
  db_engine_version     = var.db_engine_version
  db_instance_type      = var.db_instance_type
  db_username           = var.db_username
  db_password           = var.db_password
  ec2_security_group_id = module.instances.ec2_instance_ids["frontsite"][0] # Usando o SG da primeira instância frontsite como exemplo
}

module "endpoints" {
  source = "./endpoints"

  project_name            = var.project_name
  operation_name          = var.operation_name
  aws_region              = var.aws_region
  vpc_id                  = module.network.main_vpc_id
  vpc_cidr                = var.vpc_cidr_main
  private_subnet_ids      = module.network.main_private_subnet_ids
  private_route_table_ids = [module.network.main_private_route_table_id]
}

module "monitoring" {
  source = "./monitoring"

  project_name    = var.project_name
  operation_name  = var.operation_name
  log_bucket_name = var.log_bucket_name
}

data "aws_iam_policy_document" "static_content_access" {
  statement {
    sid       = "AllowCloudFrontServicePrincipalGetObject"
    actions   = ["s3:GetObject"]
    resources = ["${module.s3.static_content_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.cloudfront.cloudfront_arn] 
    }
  }

  statement {
    sid       = "AllowCloudFrontServicePrincipalListBucket"
    actions   = ["s3:ListBucket"]
    resources = ["${module.s3.static_content_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.cloudfront.cloudfront_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "static_content_policy" {
  bucket = module.s3.static_content_bucket_id
  # Referencia o JSON gerado pelo data block
  policy = data.aws_iam_policy_document.static_content_access.json 
}