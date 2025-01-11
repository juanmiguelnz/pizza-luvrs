resource "aws_security_group" "lb_sg" {
  name   = "${var.prefix}-lb-sg"
  vpc_id = data.tfe_outputs.core-infra.nonsensitive_values.vpc_id
  tags = {
    Name = "${var.prefix}-lb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.lb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80

  tags = {
    Name = "${var.prefix}-allow-http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.lb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443

  tags = {
    Name = "${var.prefix}-allow-https"
  }
}

resource "aws_security_group" "web_servers_sg" {
  name   = "${var.prefix}-web-sg"
  vpc_id = data.tfe_outputs.core-infra.nonsensitive_values.vpc_id

  tags = {
    Name = "${var.prefix}-web-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_3000" {
  security_group_id = aws_security_group.web_servers_sg.id

  referenced_security_group_id = aws_security_group.lb_sg.id
  from_port                    = 3000
  ip_protocol                  = "tcp"
  to_port                      = 3000

  tags = {
    Name = "${var.prefix}-allow-3000"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.web_servers_sg.id

  cidr_ipv4   = data.tfe_outputs.core-infra.nonsensitive_values.vpc_cidr_block
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22

  tags = {
    Name = "${var.prefix}-allow-ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ping" {
  security_group_id = aws_security_group.web_servers_sg.id

  cidr_ipv4   = data.tfe_outputs.core-infra.nonsensitive_values.vpc_cidr_block
  ip_protocol = "icmp"
  from_port   = "-1"
  to_port     = "-1"

  tags = {
    Name = "${var.prefix}-allow-ping"
  }
}