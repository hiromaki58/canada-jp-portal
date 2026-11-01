# ===== network レイヤーの outputs を読み込む =====
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "canada-jp-portal-tfstate-724775511010"
    key    = "prod/network/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  database_name = "canadajpportal"
}

# ===== DB サブネットグループ =====
resource "aws_db_subnet_group" "main" {
  name        = "canada-jp-portal-prod"
  description = "Private subnets for canada-jp-portal (prod)"
  subnet_ids  = data.terraform_remote_state.network.outputs.private_subnet_ids
}

# ===== RDS for MySQL（本番専用） =====
# アプリ用のユーザーは Terraform では作らない（MySQL の中のリソースのため）。
# 初回だけ admin ユーザーで接続して作成し、パスワードはシークレット canada-jp-portal-prod/app に入れる:
#   CREATE USER 'canadajpportal'@'%' IDENTIFIED BY '<password>' REQUIRE SSL;
#   GRANT ALL PRIVILEGES ON canadajpportal.* TO 'canadajpportal'@'%';
resource "aws_db_instance" "main" {
  identifier     = "canada-jp-portal-prod-db"
  engine         = "mysql"
  engine_version = "8.4.11" # ステージングと同じバージョン
  instance_class = "db.t3.micro"
  db_name        = local.database_name # 最初のデータベースを作成する
  username       = "admin"

  # admin のパスワードは RDS が生成して Secrets Manager で管理する（Terraform の state に残らない）
  manage_master_user_password = true

  port = 3306

  # ストレージ
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  # ネットワーク
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.rds_security_group_id]
  multi_az               = false
  publicly_accessible    = false

  parameter_group_name = "default.mysql8.4"

  # バックアップとメンテナンス
  backup_retention_period    = 7
  backup_window              = "07:20-07:50"
  maintenance_window         = "mon:03:14-mon:03:44"
  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true

  # 削除時の設定
  deletion_protection       = true
  skip_final_snapshot       = false
  final_snapshot_identifier = "canada-jp-portal-prod-db-final"

  ca_cert_identifier       = "rds-ca-rsa2048-g1"
  engine_lifecycle_support = "open-source-rds-extended-support-disabled"

  lifecycle {
    prevent_destroy = true # Terraform からの削除を禁止する
  }
}
