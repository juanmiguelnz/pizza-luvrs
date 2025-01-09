provider "aws" {
  region = "ap-southeast-2"
}

provider "tfe" {
  token = var.token
}