output "db_address" {
  value = aws_db_instance.main.address
}

output "database_name" {
  value = local.database_name
}

output "master_user_secret_arn" {
  description = "admin のパスワードが入っているシークレット（RDS が管理）"
  value       = aws_db_instance.main.master_user_secret[0].secret_arn
}
