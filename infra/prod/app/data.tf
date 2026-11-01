locals {
  name         = "canada-jp-portal-prod"
  cluster_name = "canada-jp-portal-prod" # shared レイヤーの CircleCI 用ポリシーと同じ名前
  region       = "us-east-1"
}

# ===== 他のレイヤーで作ったリソースを読み込む =====

# network レイヤー（共有 VPC の値と本番用の SG）
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "canada-jp-portal-tfstate-724775511010"
    key    = "prod/network/terraform.tfstate"
    region = "us-east-1"
  }
}

# database レイヤー（本番 RDS のエンドポイントとデータベース名）
data "terraform_remote_state" "database" {
  backend = "s3"
  config = {
    bucket = "canada-jp-portal-tfstate-724775511010"
    key    = "prod/database/terraform.tfstate"
    region = "us-east-1"
  }
}

# dns レイヤー：ホストゾーンと ACM 証明書（名前で探す）
data "aws_route53_zone" "main" {
  name = var.domain
}

data "aws_acm_certificate" "main" {
  domain      = var.domain
  statuses    = ["ISSUED"]
  most_recent = true
}

# mail レイヤー：SMTP 認証情報のシークレット
data "aws_secretsmanager_secret" "smtp" {
  name = "canada-jp-portal-prod/smtp"
}

# shared レイヤー：アプリ用シークレットと ECR
data "aws_secretsmanager_secret" "app" {
  name = "canada-jp-portal-prod/app"
}

data "aws_ecr_repository" "backend" {
  name = "canada-jp-portal-prod-backend"
}

data "aws_ecr_repository" "frontend" {
  name = "canada-jp-portal-prod-frontend"
}
