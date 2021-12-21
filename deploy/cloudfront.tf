resource "aws_cloudfront_distribution" "web_main" {
  enabled             = true
  default_root_object = "index.html"

  lifecycle {
    ignore_changes = [
      # Ignore changes to origins because of manually added aws_alb.funwithflights_service origin
      # TF bug -> https://github.com/hashicorp/terraform-provider-aws/issues/412
      origin,
      ordered_cache_behavior
    ]
  }

  origin {
    domain_name = aws_s3_bucket.web_main.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.web_main.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = aws_alb.funwithflights_service.dns_name
    origin_id   = aws_alb.funwithflights_service.name
  }

  # The public website
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.web_main.bucket
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 43200
    max_ttl                = 86400

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # Expose ALB only through CF
  ordered_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "POST"]
    cached_methods         = ["GET", "HEAD"]
    path_pattern           = "/api/*"
    target_origin_id       = aws_alb.funwithflights_service.name
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "cloudfront origin access identity"
}

output "web_main_cf_website" {
  value = aws_cloudfront_distribution.web_main.domain_name
}

output "web_main_cf_distribution" {
  value = aws_cloudfront_distribution.web_main.id
}