resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "4f24baf4-4783-4fd1-8718-258757b33ee7"

  force_destroy = true

#  versioning {
#    enabled = false
#  }
}

resource "aws_s3_bucket_public_access_block" "public_s3_block" {
  bucket = aws_s3_bucket.lambda_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}