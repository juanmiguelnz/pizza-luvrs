variable "vpc_cidr_block" {
  type    = string
  default = "10.10.0.0/16"
}


variable "public_subnet_count" {
  type    = number
  default = 3
}