# SES はアカウント単位の設定（サンドボックス、送信停止リスト、テスト用の宛先）を
# ステージング（infra/stg/mail）と共有する。ここではドメイン単位のものだけを作る。

# dns レイヤーで管理しているホストゾーンを名前で探す
data "aws_route53_zone" "main" {
  name = var.domain
}

# ===== ドメインの認証 =====
resource "aws_sesv2_email_identity" "domain" {
  email_identity = var.domain
}

# ===== DKIM 用の CNAME レコード（3 つ） =====
# これを登録すると、SES のドメイン認証が PENDING から SUCCESS に変わる
resource "aws_route53_record" "ses_dkim" {
  count   = 3
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "${aws_sesv2_email_identity.domain.dkim_signing_attributes[0].tokens[count.index]}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = 1800
  records = ["${aws_sesv2_email_identity.domain.dkim_signing_attributes[0].tokens[count.index]}.dkim.amazonses.com"]
}

# ===== DMARC レコード =====
# まずは p=none（監視のみ）で始める。運用が安定したら quarantine などに強める
resource "aws_route53_record" "dmarc" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "_dmarc.${var.domain}"
  type    = "TXT"
  ttl     = 1800
  records = ["v=DMARC1; p=none;"]
}

# ===== SMTP 用の IAM ユーザー =====
resource "aws_iam_user" "ses_smtp" {
  name = "canada-jp-portal-prod-ses-smtp"
}

resource "aws_iam_user_policy" "ses_smtp_send" {
  name = "ses-send-from-domain"
  user = aws_iam_user.ses_smtp.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "ses:SendRawEmail"
      Resource = "*"
      # 送信元が自分のドメインのアドレスのときだけ許可する
      Condition = {
        StringLike = { "ses:FromAddress" = "*@${var.domain}" }
      }
    }]
  })
}

resource "aws_iam_access_key" "ses_smtp" {
  user = aws_iam_user.ses_smtp.name
}

# ===== SMTP 認証情報を Secrets Manager に保存 =====
resource "aws_secretsmanager_secret" "smtp" {
  name        = "canada-jp-portal-prod/smtp"
  description = "SES の SMTP 認証情報"
}

resource "aws_secretsmanager_secret_version" "smtp" {
  secret_id = aws_secretsmanager_secret.smtp.id
  secret_string = jsonencode({
    host     = "email-smtp.us-east-1.amazonaws.com"
    port     = 587
    username = aws_iam_access_key.ses_smtp.id
    password = aws_iam_access_key.ses_smtp.ses_smtp_password_v4
  })
}
