# 環境（stg / prod）ごとの値は、各環境の app レイヤー（infra/<env>/app）から渡す

variable "name" {
  description = "リソース名の接頭辞（ALB、ターゲットグループ、ECS サービス、IAM ロールなど）"
  type        = string
}

variable "cluster_name" {
  description = "ECS クラスター名（shared レイヤーの CircleCI 用ポリシーと同じ名前）"
  type        = string
}

variable "project_tag" {
  description = "EC2 インスタンスに付ける Project タグ"
  type        = string
}

variable "domain" {
  description = "公開するドメイン"
  type        = string
}

variable "region" {
  type = string
}

# ===== ネットワーク =====
variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "ecs_instances_security_group_id" {
  type = string
}

# ===== DNS と証明書 =====
variable "route53_zone_id" {
  type = string
}

variable "certificate_arn" {
  type = string
}

# ===== データベース =====
variable "db_address" {
  type = string
}

variable "db_name" {
  type = string
}

# ===== シークレットとイメージ =====
variable "app_secret_arn" {
  description = "DB_USERNAME、DB_PASSWORD、APP_OTP_HMAC_KEY を持つシークレット"
  type        = string
}

variable "smtp_secret_arn" {
  description = "username、password を持つ SMTP 認証情報のシークレット"
  type        = string
}

variable "backend_repository_url" {
  type = string
}

variable "frontend_repository_url" {
  type = string
}

# ===== 台数とインスタンス =====
variable "backend_desired_count" {
  description = "backend のタスク数。初回は 0 で作り、DB とアプリ用ユーザーを作成してから 1 にする"
  type        = number
  default     = 1
}

variable "use_spot" {
  description = "true ならスポットインスタンス、false ならオンデマンドで起動する"
  type        = bool
  default     = true
}

variable "instance_types" {
  description = "起動してよいインスタンスタイプ。スポットの在庫切れに備えて、同じ大きさのものを複数並べる"
  type        = list(string)
  default     = ["t3.small", "t3a.small"] # どちらも 2 vCPU / 2 GiB
}
