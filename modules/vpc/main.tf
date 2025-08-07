# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Dynamic CIDR calculation
locals {
  # Calculate subnet mask based on VPC CIDR
  vpc_cidr_bits = tonumber(split("/", var.vpc_cidr)[1])

  # Calculate subnet size (default /24 for subnets)
  subnet_bits = 8 # /24 = 256 IPs per subnet

  # Use provided CIDRs or calculate dynamically
  public_subnet_cidrs = length(var.public_subnet_cidrs) > 0 ? var.public_subnet_cidrs : [
    for i in range(var.public_subnet_count) :
    cidrsubnet(var.vpc_cidr, local.subnet_bits, i)
  ]

  private_subnet_cidrs = length(var.private_subnet_cidrs) > 0 ? var.private_subnet_cidrs : [
    for i in range(var.private_subnet_count) :
    cidrsubnet(var.vpc_cidr, local.subnet_bits, var.public_subnet_count + i)
  ]

  # Validate that we don't exceed VPC capacity
  total_subnets = var.public_subnet_count + var.private_subnet_count
  max_subnets   = pow(2, 32 - local.vpc_cidr_bits - local.subnet_bits)
}

# Validation to ensure we don't exceed VPC capacity
resource "terraform_data" "cidr_validation" {
  input = {
    # This will fail if the condition is false
    valid = local.total_subnets <= local.max_subnets ? "true" : "false"
  }

  lifecycle {
    precondition {
      condition     = local.total_subnets <= local.max_subnets
      error_message = "Total subnet count (${local.total_subnets}) exceeds VPC capacity (${local.max_subnets}) for CIDR ${var.vpc_cidr} with /${local.subnet_bits + local.vpc_cidr_bits} subnets."
    }
  }
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "landing-zone-vpc"
  })
}

# Public subnets
resource "aws_subnet" "public" {
  count             = length(local.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(var.tags, {
    Name = "public-subnet-${count.index + 1}"
    Type = "Public"
  })
}

# Private subnets
resource "aws_subnet" "private" {
  count             = length(local.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.tags, {
    Name = "private-subnet-${count.index + 1}"
    Type = "Private"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "landing-zone-igw"
  })
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.main]

  tags = merge(var.tags, {
    Name = "landing-zone-nat-eip"
  })
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(var.tags, {
    Name = "landing-zone-nat-gateway"
  })

  depends_on = [aws_internet_gateway.main]
}

# Route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.tags, {
    Name = "public-route-table"
  })
}

# Route table for private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = merge(var.tags, {
    Name = "private-route-table"
  })
}

# Route table associations for public subnets
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Route table associations for private subnets
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
} 