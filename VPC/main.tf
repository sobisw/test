# AWS Provider

provider "aws" {
  region = var.aws_region
}

# Main VPC Creation 

resource "aws_vpc" "mable_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name        = "mable_vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}


# [Security Best Practice] 
# Creation of flow logs to capture information about IP traffic going to and from network interfaces in the VPC

resource "aws_flow_log" "mable_vpc_flow_log" {
  log_destination      = aws_s3_bucket.mable_vpc_flow_log_bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.mable_vpc.id
}

resource "aws_s3_bucket" "mable_vpc_flow_log_bucket" {
  bucket = "mable-vpc-flow-log-bucket"
}

# Create public and private subnets 

resource "aws_subnet" "public_subnet" {
  count      = length(data.aws_availability_zones.available.names)
  vpc_id     = aws_vpc.mable_vpc.id
  cidr_block = element(var.public_subnet_cidr_block, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "public_subnet_${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count      = length(data.aws_availability_zones.available.names)
  vpc_id     = aws_vpc.mable_vpc.id
  cidr_block = element(var.private_subnet_cidr_block, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "private_subnet_${count.index}"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "mable_igw" {
  vpc_id = aws_vpc.mable_vpc.id
}

# Create EIP and NAT Gateway
resource "aws_eip" "mable_nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "mable_nat_gw" {
  allocation_id = aws_eip.mable_nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 1)
  depends_on = [aws_internet_gateway.mable_igw]
}
 

# Create and associate Public Route Table
resource "aws_route_table" "mable_public_route_table" {
  vpc_id = aws_vpc.mable_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mable_igw.id
  }
}

resource "aws_route_table_association" "mable_public_route_table_association" {
  count = length(aws_subnet.public_subnet.*.id)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.mable_public_route_table.id
}

# Create and associate Private Route Table
resource "aws_route_table" "mable_private_route_table" {
  vpc_id = aws_vpc.mable_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mable_nat_gw.id
  }
}

resource "aws_route_table_association" "mable_private_route_table_association" {
  count = length(aws_subnet.private_subnet.*.id)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.mable_private_route_table.id
}
