resource "random_string" "random" {
  length  = 4
  upper   = false
  special = false
}

resource "aws_s3_bucket" "pizza" {
#   bucket = "${var.prefix}${random_string.random.result}"
    bucket = "pizzatestnz123"

  tags = {
    # Name = "${var.prefix}${random_string.random.result}"
    Name = "pizzatestnz123"
  }
}

resource "aws_s3_bucket_policy" "allow_get_object_public_access" {
  bucket = aws_s3_bucket.pizza.id
  policy = file("./s3-bucket-policy.json")
}


