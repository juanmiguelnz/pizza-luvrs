resource "aws_lb" "pizza" {
  name               = "${var.prefix}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in data.tfe_outputs.core-infra.nonsensitive_values.public_subnets : subnet.id]

  enable_deletion_protection = false

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.id
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = {
    Name = "${var.prefix}-lb"
  }
}

resource "random_string" "random" {
  length           = 4
  upper = false
  special          = false
}

resource "aws_s3_bucket" "pizza" {
  bucket = "${var.prefix}${random_string.random.result}"

  tags = {
    Name        = "${var.prefix}${random_string.random.result}"
  }
}