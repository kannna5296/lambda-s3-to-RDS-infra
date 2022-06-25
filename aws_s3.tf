resource "aws_s3_bucket" "mysample-bucket-myamane" {
  bucket = "mysample-bucket-myamane"
  acl    = "private"

  tags = {
    Name        = "mysample-bucket-myamane"
  }
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.mysample-bucket-myamane.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}