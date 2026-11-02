# ===== VPC =====
resource "aws_vpc" "main" {
  cidr_block           = "172.31.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "canada-jp-portal-stg-vpc"
    name = "canada-jp-portal"
  }

  lifecycle {
    prevent_destroy = true # RDS がいる VPC なので誤削除を防ぐ
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "canada-jp-portal-stg-Igw"
    group = "canada-jp-portal-stg"
  }
}

# ===== サブネット =====
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "us-east-1a"
  cidr_block              = "172.31.16.0/20"
  map_public_ip_on_launch = true

  tags = {
    Name = "canada-jp-portal-public-02"
    name = "canada-jp-portal"
  }
}

resource "aws_subnet" "public_1b" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "us-east-1b"
  cidr_block              = "172.31.0.0/20"
  map_public_ip_on_launch = true

  tags = {
    Name = "canada-jp-portal-public-01"
    name = "canada-jp-portal"
  }
}

resource "aws_subnet" "private_1b" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "us-east-1b"
  cidr_block              = "172.31.80.0/20"
  map_public_ip_on_launch = false

  tags = {
    Name = "WebGamePrivate01"
    name = "WebGame"
  }
}

# ===== ルートテーブル =====
# メインルートテーブル（public サブネットが暗黙的に使用）
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name  = "WebGemaRTPub"
    group = "WebGame"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  # 既存の NAT ゲートウェイへのルート（状態を確認後に整理する）
  route = []

  tags = {
    Name  = "WebGameRTPrivate"
    group = "WebGame"
  }
}

resource "aws_route_table_association" "private_1b" {
  subnet_id      = aws_subnet.private_1b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_subnet" "private_1a" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "us-east-1a"
  cidr_block              = "172.31.96.0/20"
  map_public_ip_on_launch = false

  tags = {
    Name = "canada-jp-portal-private-1a"
  }
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private.id
}

# ===== セキュリティグループ =====
# 旧 RDS 用の SG（WebGame-EKS-RDS-SG）は定義を消したので、apply すると削除される。
# 削除が済んだら、rds_new を moved で aws_security_group.rds に移す
# （旧 SG が state に残っている間に移すと、移動できずに rds_new の削除が計画されるため、apply を分ける）
# RDS 用の SG：ステージングの ECS インスタンスからの MySQL だけを受け付ける
resource "aws_security_group" "rds_new" {
  name        = "canada-jp-portal-stg-rds"
  description = "RDS for canada-jp-portal (stg)"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL from stg ECS instances"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_instances.id]
  }

  tags = {
    Name = "canada-jp-portal-stg-rds"
    name = "canada-jp-portal-stg"
  }

  lifecycle {
    prevent_destroy = true
  }
}
