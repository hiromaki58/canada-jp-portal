variable "domain" {
  description = "本番のドメイン（dns レイヤーと同じ値）"
  type        = string
}

variable "backend_desired_count" {
  description = "backend のタスク数。初回は 0 で作り、アプリ用ユーザーを作成してから 1 にする"
  type        = number
  default     = 1
}
