resource "aws_cloudfront_distribution" "cloudfront_distro" {
  enabled             = true
  comment             = "${var.project_name}-cf"
  default_root_object = "index.html"

  origin {
    domain_name = var.alb_dns_name
    origin_id   = "alb-origin"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET","HEAD","OPTIONS"]
    cached_methods         = ["GET","HEAD"]
    compress               = true
    forwarded_values {
      query_string = true
      headers      = ["Authorization","CloudFront-Viewer-Country"]
      cookies { forward = "all" }
    }
  }

  price_class = "PriceClass_100"

  restrictions { 
    geo_restriction { 
        restriction_type = "none" 
        } 
    }

  viewer_certificate {
    acm_certificate_arn            = var.certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }
}
