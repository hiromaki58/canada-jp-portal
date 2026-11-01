output "name_servers" {
  description = "レジストラに設定する NS レコード"
  value       = aws_route53_zone.main.name_servers
}

output "certificate_arn" {
  value = aws_acm_certificate_validation.main.certificate_arn
}
