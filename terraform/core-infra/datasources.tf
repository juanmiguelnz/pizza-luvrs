data "http" "icanhazip" {
  url = "http://icanhazip.com"
}

data "aws_availability_zones" "available" {
  state = "available"
}