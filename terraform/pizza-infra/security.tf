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