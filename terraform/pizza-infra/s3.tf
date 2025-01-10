# resource "random_string" "random" {
#   length  = 5
#   upper   = false
#   special = false
# }

# resource "aws_s3_bucket" "pizza" {
#   bucket = "${var.prefix}${random_string.random.result}"

#   tags = {
#     Name = "${var.prefix}${random_string.random.result}"
#   }
# }

# resource "aws_s3_bucket_ownership_controls" "pizza" {
#   bucket = aws_s3_bucket.pizza.id
#   rule {
#     object_ownership = "BucketOwnerEnforced"
#   }
# }

# resource "aws_s3_bucket_public_access_block" "pizza" {
#   bucket = aws_s3_bucket.pizza.id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# resource "aws_s3_bucket_acl" "pizza_s3_acl" {
#   depends_on = [aws_s3_bucket_public_access_block.pizza]

#   bucket = aws_s3_bucket.pizza.id
#   acl    = "public-read"
# }

# resource "aws_s3_bucket_policy" "allow_get_object_public_access" {
#   depends_on = [aws_s3_bucket_public_access_block.pizza]

#   bucket = aws_s3_bucket.pizza.id
#   policy = templatefile("./s3-bucket-policy.json", {
#     bucket_name = aws_s3_bucket.pizza.id
#   })
# }
