resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_main
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-${var.operation_name}-main-vpc-${var.aws_region}"
    Project = var.project_name
    Operation = var.operation_name
  }
}

resource "aws_vpc" "secondary" {
  cidr_block = var.vpc_cidr_secondary
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-${var.operation_name}-secondary-vpc-${var.aws_region}"
    Project = var.project_name
    Operation = var.operation_name
  }
}

resource "aws_vpc_peering_connection" "main_to_secondary" {
  peer_vpc_id = aws_vpc.secondary.id
  vpc_id      = aws_vpc.main.id
  auto_accept = true

  tags = {
    Name = "${var.project_name}-${var.operation_name}-vpc-peering-main-to-secondary"
    Project = var.project_name
    Operation = var.operation_name
  }
}

# Internet Gateway para a VPC Principal
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-${var.operation_name}-main-igw"
    Project = var.project_name
    Operation = var.operation_name
  }
}

# Sub-redes públicas na VPC Principal
resource "aws_subnet" "main_public" {
  count             = length(var.public_subnet_cidrs_main)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs_main[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.operation_name}-main-public-subnet-${count.index + 1}-${var.aws_region}"
    Project = var.project_name
    Operation = var.operation_name
  }
}

# Sub-redes privadas na VPC Principal
resource "aws_subnet" "main_private" {
  count             = length(var.private_subnet_cidrs_main)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs_main[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]

  tags = {
    Name = "${var.project_name}-${var.operation_name}-main-private-subnet-${count.index + 1}-${var.aws_region}"
    Project = var.project_name
    Operation = var.operation_name
  }
}

# Sub-redes de banco de dados na VPC Principal
resource "aws_subnet" "main_database" {
  count             = length(var.database_subnet_cidrs_main)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_cidrs_main[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]

  tags = {
    Name = "${var.project_name}-${var.operation_name}-main-database-subnet-${count.index + 1}-${var.aws_region}"
    Project = var.project_name
    Operation = var.operation_name
  }
}

# Sub-redes privadas na VPC Secundária
resource "aws_subnet" "secondary_private" {
  count             = length(var.private_subnet_cidrs_secondary)
  vpc_id            = aws_vpc.secondary.id
  cidr_block        = var.private_subnet_cidrs_secondary[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]

  tags = {
    Name = "${var.project_name}-${var.operation_name}-secondary-private-subnet-${count.index + 1}-${var.aws_region}"
    Project = var.project_name
    Operation = var.operation_name
  }
}

# Elastic IP para NAT Gateway
resource "aws_eip" "nat_gateway" {

  tags = {
    Name = "${var.project_name}-${var.operation_name}-nat-eip"
    Project = var.project_name
    Operation = var.operation_name
  }
}

# NAT Gateway na VPC Principal (em uma sub-rede pública)
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.main_public[0].id # Associa ao primeiro subnet público

  tags = {
    Name = "${var.project_name}-${var.operation_name}-main-nat-gateway"
    Project = var.project_name
    Operation = var.operation_name
  }

  depends_on = [aws_internet_gateway.main]
}

# Tabelas de Roteamento

# Tabela de roteamento pública para a VPC Principal
resource "aws_route_table" "main_public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-${var.operation_name}-main-public-rt"
    Project = var.project_name
    Operation = var.operation_name
  }
}

# Associa as sub-redes públicas à tabela de roteamento pública
resource "aws_route_table_association" "main_public" {
  count          = length(aws_subnet.main_public)
  subnet_id      = aws_subnet.main_public[count.index].id
  route_table_id = aws_route_table.main_public.id
}

# Tabela de roteamento privada para a VPC Principal
resource "aws_route_table" "main_private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  route {
    cidr_block                = var.vpc_cidr_secondary
    vpc_peering_connection_id = aws_vpc_peering_connection.main_to_secondary.id
  }

  tags = {
    Name = "${var.project_name}-${var.operation_name}-main-private-rt"
    Project = var.project_name
    Operation = var.operation_name
  }
}

# Associa as sub-redes privadas e de banco de dados à tabela de roteamento privada
resource "aws_route_table_association" "main_private" {
  count          = length(aws_subnet.main_private)
  subnet_id      = aws_subnet.main_private[count.index].id
  route_table_id = aws_route_table.main_private.id
}

resource "aws_route_table_association" "main_database" {
  count          = length(aws_subnet.main_database)
  subnet_id      = aws_subnet.main_database[count.index].id
  route_table_id = aws_route_table.main_private.id
}

# Tabela de roteamento privada para a VPC Secundária
resource "aws_route_table" "secondary_private" {
  vpc_id = aws_vpc.secondary.id

  route {
    cidr_block                = var.vpc_cidr_main
    vpc_peering_connection_id = aws_vpc_peering_connection.main_to_secondary.id
  }

  tags = {
    Name = "${var.project_name}-${var.operation_name}-secondary-private-rt"
    Project = var.project_name
    Operation = var.operation_name
  }
}

# Associa as sub-redes privadas da VPC Secundária à tabela de roteamento privada
resource "aws_route_table_association" "secondary_private" {
  count          = length(aws_subnet.secondary_private)
  subnet_id      = aws_subnet.secondary_private[count.index].id
  route_table_id = aws_route_table.secondary_private.id
}


