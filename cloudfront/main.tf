resource "aws_cloudfront_distribution" "static_content_cdn" {
  origin {
    domain_name = var.s3_bucket_regional_domain_name
    origin_id   = var.s3_origin_id

    origin_access_control_id = var.cloudfront_oac_id
    }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CDN para conteúdo estático do ${var.project_name}-${var.operation_name}"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = var.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "${var.project_name}-${var.operation_name}-cloudfront-cdn"
    Project = var.project_name
    Operation = var.operation_name
  }
}

