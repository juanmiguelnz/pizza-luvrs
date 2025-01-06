resource "aws_vpc" "core_vpc" {
  cidr_block = "10.10.0.0/16"
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

resource "aws_subnet" "mgmtsubnet" {
  vpc_id     = aws_vpc.core_vpc.id
  cidr_block = "10.10.99.0/24"

  tags = {
    Name = "mgmt-subnet"
  }
}

resource "aws_subnet" "subneta" {
  vpc_id     = aws_vpc.core_vpc.id
  cidr_block = "10.10.1.0/24"

  tags = {
    Name = "subneta"
  }
}

resource "aws_subnet" "subnetb" {
  vpc_id     = aws_vpc.core_vpc.id
  cidr_block = "10.10.2.0/24"

  tags = {
    Name = "subnetb"
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

resource "aws_route_table_association" "subneta" {
  subnet_id      = aws_subnet.subneta.id
  route_table_id = aws_route_table.internet.id
}

resource "aws_route_table_association" "subnetb" {
  subnet_id      = aws_subnet.subnetb.id
  route_table_id = aws_route_table.internet.id
}