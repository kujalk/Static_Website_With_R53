#Create an ACM Certificate
resource "aws_acm_certificate" "https_certificate" {
  domain_name = var.root_domain_name
  validation_method = "DNS"
}


resource "aws_route53_record" "htpps_cert_dns" {
  for_each = {
    for dvo in aws_acm_certificate.https_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.aws_route53_zone_id
}

resource "aws_acm_certificate_validation" "htpps_cert_dns" {
  timeouts {
    create = "5m"
  }
  certificate_arn         = aws_acm_certificate.https_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.htpps_cert_dns : record.fqdn]
}