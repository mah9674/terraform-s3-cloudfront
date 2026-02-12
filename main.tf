resource "aws_s3_bucket" "bucket" {
  bucket = "demo-terraform-bucket-1234567"
}
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "demo-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
resource "aws_cloudfront_distribution" "cf" {

  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id   = "s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  enabled = true

  default_cache_behavior {
    target_origin_id = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
