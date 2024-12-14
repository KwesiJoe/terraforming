resource "aws_s3_bucket" "s3_bucket" {
  for_each = var.origins
  bucket   = each.value.bucket
}


resource "aws_cloudfront_origin_access_control" "origin_access_control" {
  name                              = var.origin_access_control_name
  description                       = "origin access control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  for_each   = var.origins
  bucket     = aws_s3_bucket.s3_bucket[each.key].id
  depends_on = [aws_s3_bucket.s3_bucket, aws_cloudfront_origin_access_control.origin_access_control]
  policy     = <<EOF

  {
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.s3_bucket[each.key].arn}/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "${aws_cloudfront_distribution.cloudfront_distribution[each.key].arn}"
                }
            }
        }
    ]
}

  EOF
}

resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  for_each   = var.origins
  depends_on = [aws_s3_bucket.s3_bucket, aws_cloudfront_origin_access_control.origin_access_control]
  origin {
    domain_name              = aws_s3_bucket.s3_bucket[each.key].bucket_regional_domain_name
    origin_id                = aws_s3_bucket.s3_bucket[each.key].id
    origin_access_control_id = aws_cloudfront_origin_access_control.origin_access_control.id

    s3_origin_config {
      origin_access_identity = "" # If using an OAI, specify the ID here
    }
  }

  enabled             = true
  default_root_object = "index.html" # Specify your default root object

  # Add any other necessary distribution configurations
  aliases = each.value.aliases
  comment = each.value.comment

  default_cache_behavior {
    target_origin_id = aws_s3_bucket.s3_bucket[each.key].id

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["HEAD", "GET", "OPTIONS"]
    cached_methods  = ["HEAD", "GET", "OPTIONS"]
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                   = 0
    default_ttl               = 3600
    max_ttl                   = 86400
    compress                  = true
    smooth_streaming          = false
    field_level_encryption_id = ""

    # Add any other necessary cache behavior configurations
  }

  # Custom error response for 400 and 403 errors
  custom_error_response {
    error_code         = 400
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  # Add any other necessary CloudFront distribution configurations
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}
