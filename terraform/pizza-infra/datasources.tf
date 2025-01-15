data "tfe_outputs" "core-infra" {
  organization = "specialised-tfc"
  workspace    = "core-infra-develop"
}

data "http" "local_ip" {
  url = "https://api64.ipify.org?format=text"
}