resource "aws_instance" "mgmtvm" {
  ami                         = "ami-0ce4704e01dabf5a1"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.mgmtsubnet.id
  vpc_security_group_ids      = [aws_security_group.mgmtinstancesg.id]
  associate_public_ip_address = true
  iam_instance_profile        = "0PLoversInstanceProfile"

  tags = {
    Name        = "mgmtvm"
    Environment = "develop"
    Billing     = "123456789"
  }
}
