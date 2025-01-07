resource "aws_security_group" "mgmtinstancesg" {
  name   = "mgmt-sg"
  vpc_id = aws_vpc.core_vpc.id
  tags = {
    Name = "pizza"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allowssh" {
  security_group_id = aws_security_group.mgmtinstancesg.id

  cidr_ipv4   = "${(chomp(data.http.icanhazip.response_body))}/32"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22

  tags = {
    Name = "allow-ssh"
  }
}