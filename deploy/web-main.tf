# Pricate S3 bucket to hold the site
resource "aws_s3_bucket" "web_main" {
  bucket        = "s3-web-main"
  acl           = "private"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "cloudfront origin access identity"
}

# Custom policy for CF to access the bucket
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.web_main.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.web_main.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

# Give CF access to the private bucket
resource "aws_s3_bucket_policy" "policy_for_cloudfront" {
  bucket = aws_s3_bucket.web_main.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_cloudfront_distribution" "web_main" {
  enabled = true

  origin {
    domain_name = aws_s3_bucket.web_main.bucket_domain_name
    origin_id   = aws_s3_bucket.web_main.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.web_main.bucket
    viewer_protocol_policy = "redirect-to-https"
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

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

output "web_main_cf_website" {
  value = aws_cloudfront_distribution.web_main.domain_name
}