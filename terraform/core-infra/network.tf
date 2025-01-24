resource "aws_vpc" "core_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "pizza"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.core_vpc.id

  tags = {
    Name = "pizza"
  }
}

resource "aws_subnet" "public_subnets" {
  count = var.public_subnet_count

  vpc_id            = aws_vpc.core_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "public_subnet${count.index}"
  }
}

resource "aws_subnet" "mgmtsubnet" {
  vpc_id     = aws_vpc.core_vpc.id
  cidr_block = "10.10.99.0/24"

  tags = {
    Name = "mgmt_subnet"
  }
}

resource "aws_route_table" "internet" {
  vpc_id = aws_vpc.core_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "pizza-internet-rt"
  }
}

resource "aws_route_table_association" "mgmtsubnet" {
  subnet_id      = aws_subnet.mgmtsubnet.id
  route_table_id = aws_route_table.internet.id
}

resource "aws_route_table_association" "public_subnets" {
  count = var.public_subnet_count

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.internet.id
}
