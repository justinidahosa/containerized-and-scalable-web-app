resource "aws_cloudfront_distribution" "frontend_cf" {
  enabled             = true
  comment             = "${var.project_name}-frontend-cf"
  default_root_object = "index.html"

  origin {
    domain_name = var.s3_bucket_domain_name       
    origin_id   = "s3-frontend"

    s3_origin_config {
      origin_access_identity = var.oai_path
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3-frontend"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    Name = "${var.project_name}-frontend-cf"
  }
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "${var.project_name}-oai"
}


