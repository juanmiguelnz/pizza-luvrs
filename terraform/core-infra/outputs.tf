output "vpc_id" {
  value = aws_vpc.core_vpc.id
}

output "mgmtsubnet_id" {
  value = aws_subnet.mgmtsubnet.id
}