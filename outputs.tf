output "alb_hostname" {
  value = "${aws_alb.main.dns_name}"
}
output "cf_domain_name" {
  value = "${aws_cloudfront_distribution.webapp.domain_name}"
}
