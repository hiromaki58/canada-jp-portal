# CircleCI の deploy-prod ジョブのパラメーターと同じ値
output "ECS_CLUSTER" {
  value = module.app.cluster_name
}

output "ECS_BACKEND_SERVICE" {
  value = module.app.backend_service_name
}

output "ECS_FRONTEND_SERVICE" {
  value = module.app.frontend_service_name
}

# 動作確認用
output "alb_dns_name" {
  value = module.app.alb_dns_name
}

output "app_url" {
  value = "https://${var.domain}"
}
