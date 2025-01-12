output "vpc_id" {
  value = aws_vpc.core_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public_subnets
}

output "mgmtsubnet_id" {
  value = aws_subnet.mgmtsubnet.id
}

output "mgmtinstancesg_id" {
  value = aws_security_group.mgmtinstancesg.id
}

output "mgmtvm_pip" {
  value = aws_instance.mgmtvm.public_ip
}

output "vpc_cidr_block" {
  value = var.vpc_cidr_block
}

output "route_table_id" {
  value = aws_route_table.internet.id
}

output "name" {
  value = var.region
}