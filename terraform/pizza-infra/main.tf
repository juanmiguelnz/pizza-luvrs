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

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = data.tfe_outputs.core-infra.nonsensitive_values.vpc_id
  service_name = "com.amazonaws.${data.tfe_outputs.core-infra.nonsensitive_values.region}.s3"

  tags = {
    Name = "${var.prefix}-s3-endpoint"
  }
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = data.tfe_outputs.core-infra.nonsensitive_values.route_table_id
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = data.tfe_outputs.core-infra.nonsensitive_values.vpc_id
  service_name = "com.amazonaws.${data.tfe_outputs.core-infra.nonsensitive_values.region}.dynamodb"

  tags = {
    Name = "${var.prefix}-dynamodb-endpoint"
  }
}

resource "aws_vpc_endpoint_route_table_association" "dynamodb" {
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
  route_table_id  = data.tfe_outputs.core-infra.nonsensitive_values.route_table_id
}

resource "aws_db_subnet_group" "postgres" {
  name       = "${var.prefix}-postgres"
  subnet_ids = [for subnet in data.tfe_outputs.core-infra.nonsensitive_values.public_subnets : subnet.id]

  tags = {
    Name = "${var.prefix}-postgres"
  }
}

resource "aws_ssm_parameter" "pizza_db_name" {
  type  = "SecureString"
  name  = "pizza_db_name"
  value = var.pizza_db_name
}

resource "aws_ssm_parameter" "pizza_db_user" {
  type  = "SecureString"
  name  = "pizza_db_user"
  value = var.pizza_db_user
}

resource "aws_ssm_parameter" "pizza_db_pass" {
  type  = "SecureString"
  name  = "pizza_db_pass"
  value = var.pizza_db_pass
}

resource "aws_ssm_parameter" "pizza_db_host" {
  type  = "SecureString"
  name  = "pizza_db_host"
  value = aws_db_instance.postgres.address
}

resource "aws_db_instance" "postgres" {
  identifier             = "${var.prefix}-postgres"
  instance_class         = "db.t3.micro"
  engine                 = "postgres"
  engine_version         = "12.16"
  allocated_storage      = 10
  skip_final_snapshot    = true
  publicly_accessible    = true
  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_name                = aws_ssm_parameter.pizza_db_name.value
  username               = aws_ssm_parameter.pizza_db_user.value
  password               = aws_ssm_parameter.pizza_db_pass.value
}

resource "aws_dynamodb_table" "toppings" {
  name     = "toppings"
  hash_key = "toppings"

  attribute {
    name = "toppings"
    type = "S"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "users" {
  name     = "users"
  hash_key = "users"

  attribute {
    name = "users"
    type = "S"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_instance" "pizza" {

  ami                         = "ami-02803e2f27171f1f5"
  instance_type               = "t2.micro"
  subnet_id                   = data.tfe_outputs.core-infra.nonsensitive_values.public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.web_servers_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = data.tfe_outputs.core-infra.nonsensitive_values.instance_profile

  user_data = <<-EOF
              #!/bin/bash
              echo "POSTGRES_HOST=$(aws ssm get-parameter --name ${aws_ssm_parameter.pizza_db_host.name} --query "Parameter.Value" --with-decryption --output text)" | tee -a /etc/environment
              echo "POSTGRES_DB=$(aws ssm get-parameter --name ${aws_ssm_parameter.pizza_db_name.name} --query "Parameter.Value" --with-decryption --output text)" | tee -a /etc/environment
              echo "POSTGRES_USER=$(aws ssm get-parameter --name ${aws_ssm_parameter.pizza_db_user.name} --query "Parameter.Value" --with-decryption --output text)" | tee -a /etc/environment
              echo "POSTGRES_PW=$(aws ssm get-parameter --name ${aws_ssm_parameter.pizza_db_pass.name} --query "Parameter.Value" --with-decryption --output text)" | tee -a /etc/environment
              source /etc/environment
              curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
              source ~/.bashrc
              cd /home/ec2-user/pizza-luvrs/
              nvm install 18
              nvm use 18
              node -v
              npm -v
              echo $POSTGRES_HOST
              nohup npm start &
              EOF

  user_data_replace_on_change = true

  tags = {
    Name        = "${var.prefix}"
    Environment = "develop"
    Billing     = "123456789"
  }
}
