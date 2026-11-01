# ===== ALB 用の SG =====
# インターネットから 80（HTTP → HTTPS へリダイレクト）と 443 を受け付ける
resource "aws_security_group" "alb" {
  name        = "canada-jp-portal-stg-alb"
  description = "ALB for canada-jp-portal (stg)"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP (redirected to HTTPS)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "canada-jp-portal-stg-alb"
  }

  # 名前を変えると作り直しになる。RDS などの SG から参照されているので、新しい SG を先に作って
  # 参照を付け替えてから古い SG を削除する
  lifecycle {
    create_before_destroy = true
  }
}

# ===== ECS の EC2 インスタンス用の SG =====
# コンテナは bridge モードで動き、ホスト側のポートは自動で割り当てられる（32768〜65535）
# そのポートへは ALB からの通信だけを許可する
resource "aws_security_group" "ecs_instances" {
  name        = "canada-jp-portal-stg-ecs-instances"
  description = "ECS container instances for canada-jp-portal (stg)"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Dynamic host ports from ALB"
    from_port       = 32768
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # ECR、Secrets Manager、SES、CloudWatch Logs などへ出ていく通信
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "canada-jp-portal-stg-ecs-instances"
  }

  # 名前を変えると作り直しになる。RDS などの SG から参照されているので、新しい SG を先に作って
  # 参照を付け替えてから古い SG を削除する
  lifecycle {
    create_before_destroy = true
  }
}
