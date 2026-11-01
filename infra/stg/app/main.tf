# ステージング環境（hiromaki58.com）。リソースの定義は modules/app にあり、ここでは環境ごとの値だけを渡す
module "app" {
  source = "../../modules/app"

  name         = local.name
  cluster_name = local.cluster_name
  project_tag  = "canada-jp-portal"
  domain       = local.domain
  region       = local.region

  vpc_id                          = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_ids               = data.terraform_remote_state.network.outputs.public_subnet_ids
  alb_security_group_id           = data.terraform_remote_state.network.outputs.alb_security_group_id
  ecs_instances_security_group_id = data.terraform_remote_state.network.outputs.ecs_instances_security_group_id

  route53_zone_id = data.aws_route53_zone.main.zone_id
  certificate_arn = data.aws_acm_certificate.main.arn

  db_address = data.aws_db_instance.main.address
  db_name    = "crossborderpayment"

  app_secret_arn          = data.aws_secretsmanager_secret.app.arn
  smtp_secret_arn         = data.aws_secretsmanager_secret.smtp.arn
  backend_repository_url  = data.aws_ecr_repository.backend.repository_url
  frontend_repository_url = data.aws_ecr_repository.frontend.repository_url

  backend_desired_count = var.backend_desired_count
  use_spot              = true
}
