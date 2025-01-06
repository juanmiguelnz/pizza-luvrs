output "vpc_id" {
  value = aws_vpc.core_vpc.id
}

output "mgmtsubnet_id" {
  value = aws_subnet.mgmtsubnet.id
}

output "mgmtinstancesg_id" {
  value = aws_security_group.mgmtinstancesg.id
}