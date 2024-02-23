
resource "aws_cloudfront_origin_access_identity" "cf" {
  comment = "${var.project} CloudFront Origin Access Identity"
}

resource "aws_cloudfront_distribution" "s3_distribution" {

  aliases = [var.root_domain_name]
  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id   = var.project

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cf.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.project} CloudFront Distribution"
  default_root_object = var.root-object

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.project

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.https_certificate.arn
    ssl_support_method  = "sni-only"
  }
}