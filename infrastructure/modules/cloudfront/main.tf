resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "oac-s3"
  description                       = "OAC for S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "dist" {
  enabled             = true
  aliases             = [var.domain_name]
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  origin {
    origin_id                = "s3-static"
    domain_name              = var.s3_bucket_domain_name 
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  origin {
    origin_id   = "apigw"
    domain_name = replace(replace(var.api_domain_name, "https://", ""), "http://", "")
    origin_path = "/prod"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3-static"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed: CachingOptimized
  }


  # 1) EXACT /api (so /api does NOT fall back to S3)
  ordered_cache_behavior {
    path_pattern           = "/api"
    target_origin_id       = "apigw"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]

    # Managed: CachingDisabled
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    # Managed: AllViewerExceptHostHeader (forwards Authorization, strips Host)
    origin_request_policy_id = "b689b0a8-53d0-40ab-baf2-68738e2966ac"
  }

  # 2) /api/* (all other API routes)
  ordered_cache_behavior {
    path_pattern           = "/api/*"
    target_origin_id       = "apigw"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]

    # Managed: CachingDisabled
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    # Managed: AllViewerExceptHostHeader (forwards Authorization, strips Host)
    origin_request_policy_id = "b689b0a8-53d0-40ab-baf2-68738e2966ac"
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

# S3 bucket policy allowing this CF distribution (via OAC) to read objects
resource "aws_s3_bucket_policy" "allow_cf" {
  bucket = var.s3_bucket_name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid       : "AllowCloudFrontOACRead",
      Effect    : "Allow",
      Principal : { Service : "cloudfront.amazonaws.com" },
      Action    : ["s3:GetObject"],
      Resource  : ["${var.s3_bucket_arn}/*"],
      Condition : {
        StringEquals : {
          "AWS:SourceArn" : aws_cloudfront_distribution.dist.arn
        }
      }
    }]
  })
}
