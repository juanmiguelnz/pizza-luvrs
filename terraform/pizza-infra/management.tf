resource "aws_instance" "mgmtvm" {
  ami                         = "ami-0ce4704e01dabf5a1"
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-00ce67d1525cc8ff4"
  vpc_security_group_ids      = ["sg-04508fac444f9bac6"]
  associate_public_ip_address = true
  iam_instance_profile        = "EC2WithFullS3AccessRole"

  tags = {
    Name = "mgmtvm"
  }
}
