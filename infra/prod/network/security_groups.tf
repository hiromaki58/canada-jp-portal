# ===== ALB 用の SG =====
# インターネットから 80（HTTP → HTTPS へリダイレクト）と 443 を受け付ける
resource "aws_security_group" "alb" {
  name        = "canada-jp-portal-prod-alb"
  description = "ALB for canada-jp-portal (prod)"
  vpc_id      = local.vpc_id

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
    Name = "canada-jp-portal-prod-alb"
  }
}

# ===== ECS の EC2 インスタンス用の SG =====
# コンテナは bridge モードで動き、ホスト側のポートは自動で割り当てられる（32768〜65535）
# そのポートへは ALB からの通信だけを許可する
resource "aws_security_group" "ecs_instances" {
  name        = "canada-jp-portal-prod-ecs-instances"
  description = "ECS container instances for canada-jp-portal (prod)"
  vpc_id      = local.vpc_id

  ingress {
    description     = "Dynamic host ports from ALB"
    from_port       = 32768
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # ECR、Secrets Manager、SES、CloudWatch Logs、RDS などへ出ていく通信
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "canada-jp-portal-prod-ecs-instances"
  }
}

# ===== 本番 RDS 用の SG =====
# 本番の ECS インスタンスからの MySQL だけを受け付ける（ステージングからは接続できない）
resource "aws_security_group" "rds" {
  name        = "canada-jp-portal-prod-rds"
  description = "RDS for canada-jp-portal (prod)"
  vpc_id      = local.vpc_id

  ingress {
    description     = "MySQL from prod ECS instances"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_instances.id]
  }

  tags = {
    Name = "canada-jp-portal-prod-rds"
  }
}
