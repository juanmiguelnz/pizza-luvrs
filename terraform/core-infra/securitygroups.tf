resource "aws_security_group" "mgmtinstancesg" {
  name   = "mgmt-sg"
  vpc_id = aws_vpc.core_vpc.id
  tags = {
    Name = "pizza"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.mgmtinstancesg.id

  cidr_ipv4   = "${(chomp(data.http.icanhazip.response_body))}/32"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22

  tags = {
    Name = "${var.prefix}-allow-ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_3000" {
  security_group_id = aws_security_group.mgmtinstancesg.id

  cidr_ipv4   = "${(chomp(data.http.icanhazip.response_body))}/32"
  from_port   = 3000
  ip_protocol = "tcp"
  to_port     = 3000

  tags = {
    Name = "${var.prefix}-allow-http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_80" {
  security_group_id = aws_security_group.mgmtinstancesg.id

  cidr_ipv4   = "${(chomp(data.http.icanhazip.response_body))}/32"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80

  tags = {
    Name = "${var.prefix}-allow-http"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outgoing_traffic" {
  security_group_id = aws_security_group.mgmtinstancesg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1

  tags = {
    Name = "${var.prefix}-allow-all-outgoing-traffic"
  }
}