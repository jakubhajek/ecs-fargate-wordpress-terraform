resource "aws_cloudfront_distribution" "webapp" {
  depends_on = [
    "aws_alb.main",
  ]

  origin {
    domain_name = "${aws_alb.main.dns_name}"

    origin_id = "alb-asa-webapp"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"

      origin_ssl_protocols = [
        "SSLv3",
        "TLSv1",
      ]
    }
  }

  aliases = "${var.cf-webapp-aliases}"

  enabled = true

  #logging_config {
  #  include_cookies = false
  #  bucket          = "alb-asa-webapp-logs"
  #}

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  tags {
    Environment = "${var.environment}"
  }
  viewer_certificate {
    cloudfront_default_certificate = true
    ssl_support_method             = "sni-only"
  }
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "alb-asa-webapp"

    forwarded_values {
      query_string = true
      headers      = ["Host", "Origin"]

      cookies {
        forward           = "none"
      }
    }

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = "${var.min_ttl}"
    default_ttl            = "${var.default_ttl}"
    max_ttl                = "${var.max_ttl}"
  }
  ordered_cache_behavior {
    path_pattern     = "wp-admin/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "alb-asa-webapp"

    forwarded_values {
      query_string = true
      headers      = ["Host", "Origin"]

      cookies {
        forward = "all"
      }
    }

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
  ordered_cache_behavior {
    path_pattern     = "wp-login.php"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "alb-asa-webapp"

    forwarded_values {
      query_string = true
      headers      = ["Host", "Origin"]

      cookies {
        forward           = "whitelist"
        whitelisted_names = "${var.cookies_whitelisted_names}"
      }
    }

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "wp-includes/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "alb-asa-webapp"

    forwarded_values {
      query_string = true
      headers      = ["Host", "Origin"]

      cookies {
        forward           = "none"
      }
    }
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

ordered_cache_behavior {
    path_pattern     = "wp-content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "alb-asa-webapp"

    forwarded_values {
      query_string = true
      headers      = ["Host", "Origin"]

      cookies {
        forward           = "none"
      }
    }
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
}
