# ===== ホストゾーン =====
# ドメインを他社で取得した場合は、outputs の name_servers をレジストラの NS レコードに設定する。
# Route 53 で取得した場合は自動で作られたホストゾーンがあるので、apply の前に import する。
resource "aws_route53_zone" "main" {
  name = var.domain
}

# ===== ACM 証明書（ALB 用） =====
resource "aws_acm_certificate" "main" {
  domain_name       = var.domain
  validation_method = "DNS"
  key_algorithm     = "RSA_2048"

  tags = {
    Name = "canada-jp-portal"
  }

  lifecycle {
    create_before_destroy = true # ALB のリスナーが使っている証明書を先に消さない
  }
}

# DNS 検証用の CNAME レコード
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for o in aws_acm_certificate.main.domain_validation_options : o.domain_name => {
      name   = o.resource_record_name
      type   = o.resource_record_type
      record = o.resource_record_value
    }
  }

  zone_id         = aws_route53_zone.main.zone_id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  ttl             = 300
  allow_overwrite = true
}

# 証明書が ISSUED になるまで待つ（NS をレジストラに設定するまでは完了しない）
resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}
