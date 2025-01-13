data "tfe_outputs" "core-infra" {
  organization = "specialised-tfc"
  workspace    = "core-infra-develop"
}

data "http" "local_ip" {
  url = "https://api64.ipify.org?format=text"
}

data "aws_ssm_parameter" "pizza_db_name" {
  name = "pizza-db-name"
}

data "aws_ssm_parameter" "pizza_db_user" {
  name = "pizza-db-user"
}

data "aws_ssm_parameter" "pizza_db_pass" {
  name = "pizza-db-pass"
}