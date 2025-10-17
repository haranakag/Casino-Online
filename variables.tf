variable "aws_region" {
  description = "Región de AWS donde se implementará la infraestructura."
  type        = string
  default     = "ca-central-1"
}

variable "project_name" {
  description = "Nombre del proyecto para nombrar recursos."
  type        = string
  default     = "cassino"
}

variable "operation_name" {
  description = "Nombre de la operación para nombrar recursos."
  type        = string
  default     = "online"
}

variable "azs" {
  description = "Lista de zonas de disponibilidad a utilizar."
  type        = list(string)
  default     = ["ca-central-1a", "ca-central-1b"]
}

variable "vpc_cidr_main" {
  description = "CIDR de VPC Principal."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_cidr_secondary" {
  description = "CIDR de VPC Secundária."
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidrs_main" {
  description = "Lista de CIDRs para sub-redes públicas en VPC Principal."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs_main" {
  description = "Lista de CIDRs para sub-redes privadas en VPC Principal."
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "database_subnet_cidrs_main" {
  description = "Lista de CIDR para subredes de bases de datos en VPC principal."
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "private_subnet_cidrs_secondary" {
  description = "Lista de CIDR para subredes privadas en la VPC secundaria."
  type        = list(string)
  default     = ["10.1.10.0/24", "10.1.11.0/24"]
}

variable "alb_certificate_arn" {
  description = "ARN do certificado ACM para o ALB."
  type        = string
  # Este valor debe completarse con un ARN de certificado válido.
  # Ejemplo: "arn:aws:acm:ca-central-1:123456789012:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  default = ""
}

variable "ec2_instance_type" {
  description = "Tipo de instancia EC2 para aplicaciones."
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "ID de AMI para instancias EC2."
  type        = string
  # Necesitará encontrar una AMI adecuada para ca-central-1, por ejemplo, una AMI de Amazon Linux 2.
  # Ejemplo: "ami-0abcdef1234567890"
  default = "ami-0b135114708752253" # Amazon Linux 2 AMI (HVM) - SSD Volume Type (ca-central-1)
}

variable "db_instance_type" {
  description = "Tipo de instancia RDS para la base de datos principal."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Tamaño de almacenamiento asignado a la base de datos principal (GB)."
  type        = number
  default     = 20
}

variable "db_engine" {
  description = "Motor de base de datos central."
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Versión del motor de base de datos principal."
  type        = string
  default     = "8.0.28"
}

variable "db_username" {
  description = "Nombre de usuario maestro para la base de datos maestra."
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Contraseña maestra para la base de datos principal."
  type        = string
  sensitive   = true
}

variable "redis_instance_type" {
  description = "Tipo de instancia para ElastiCache Redis."
  type        = string
  default     = "cache.t3.micro"
}

variable "s3_bucket_name" {
  description = "Nombre del depósito S3 para contenido estático."
  type        = string
}

variable "log_bucket_name" {
  description = "Nombre del depósito S3 para los registros de acceso de ALB."
  type        = string
}

variable "redshift_node_type" {
  description = "Tipo de nodo para Redshift (si se utiliza en VPC secundaria)."
  type        = string
  default     = "dc2.large"
}

variable "redshift_cluster_type" {
  description = "Tipo de clúster para Redshift (si se utiliza en VPC secundaria)."
  type        = string
  default     = "single-node"
}

variable "redshift_master_username" {
  description = "Nombre de usuario maestro para Redshiftt."
  type        = string
  default     = "redshiftadmin"
}

variable "redshift_master_password" {
  description = "Contraseña maestra para Redshift."
  type        = string
  sensitive   = true
}

