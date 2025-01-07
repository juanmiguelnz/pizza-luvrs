data "tfe_outputs" "core-infra" {
  organization = "specialised-tfc"
  workspace    = "core-infra-develop"
}

data "http" "icanhazip" {
  url = "http://icanhazip.com"
}
