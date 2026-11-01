locals {
  name         = "canada-jp-portal-stg"
  cluster_name = "canada-jp-portal-stg" # shared レイヤーの CircleCI 用ポリシーと同じ名前
  domain       = "hiromaki58.com"
  region       = "us-east-1"
}

# ===== 他のレイヤーで作ったリソースを読み込む =====

# network レイヤー（outputs.tf があるので state から読む）
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "canada-jp-portal-tfstate-724775511010"
    key    = "stg/network/terraform.tfstate"
    region = "us-east-1"
  }
}

# dns レイヤー：ホストゾーンと ACM 証明書（名前で探す）
data "aws_route53_zone" "main" {
  name = local.domain
}

data "aws_acm_certificate" "main" {
  domain      = local.domain
  statuses    = ["ISSUED"]
  most_recent = true
}

# database レイヤー：RDS のエンドポイント
data "aws_db_instance" "main" {
  db_instance_identifier = "canada-jp-portal-stg-db"
}

# mail レイヤー：SMTP 認証情報のシークレット
data "aws_secretsmanager_secret" "smtp" {
  name = "canada-jp-portal-stg/smtp"
}

# shared レイヤー：アプリ用シークレットと ECR
data "aws_secretsmanager_secret" "app" {
  name = "canada-jp-portal-stg/app"
}

data "aws_ecr_repository" "backend" {
  name = "canada-jp-portal-stg-backend"
}

data "aws_ecr_repository" "frontend" {
  name = "canada-jp-portal-stg-frontend"
}
