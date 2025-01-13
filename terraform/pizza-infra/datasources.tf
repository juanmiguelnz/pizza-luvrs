data "tfe_outputs" "core-infra" {
  organization = "specialised-tfc"
  workspace    = "core-infra-develop"
}

data "aws_ssm_parameter" "pizza_db_name" {
  name = "pizza-db-name"
  type = "SecureString"
}

data "aws_ssm_parameter" "pizza_db_user" {
  name = "pizza-db-user"
  type = "SecureString"
}

data "aws_ssm_parameter" "pizza_db_pass" {
  name = "pizza-db-pass"
  type = "SecureString"
}