resource "aws_s3_bucket" "static_content" {
  bucket = var.s3_bucket_name

  tags = {
    Name = "${var.project_name}-${var.operation_name}-static-content-bucket"
    Project = var.project_name
    Operation = var.operation_name
  }
}

resource "aws_s3_bucket_acl" "static_content_acl" {
  bucket = aws_s3_bucket.static_content.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "static_content_versioning" {
  bucket = aws_s3_bucket.static_content.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "static_content_sse" {
  bucket = aws_s3_bucket.static_content.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "static_content_public_access_block" {
  bucket = aws_s3_bucket.static_content.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# OAC (Origin Access Control) para CloudFront acessar S3
resource "aws_cloudfront_origin_access_control" "static_content_oac" {
  name                              = "${aws_s3_bucket.static_content.bucket}-oac"
  description                       = "OAC for ${aws_s3_bucket.static_content.bucket}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

