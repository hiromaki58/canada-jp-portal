# ===== ECS のコンテナを動かす EC2 インスタンス =====

# ECS 用に最適化された最新の Amazon Linux 2023 の AMI
data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended/image_id"
}

# インスタンスタイプは ASG の mixed_instances_policy で指定する（var.instance_types）
resource "aws_launch_template" "ecs" {
  name_prefix = "${var.name}-ecs-"
  image_id    = data.aws_ssm_parameter.ecs_ami.insecure_value

  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs_instance.arn
  }

  # パブリックサブネットに置き、外へ出る通信（ECR、SES など）用にパブリック IP を付ける。
  # 入ってくる通信は SG で ALB からだけに絞っている
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.ecs_instances_security_group_id]
  }

  # IMDSv2 を必須にし、hop limit を 1 にしてコンテナからインスタンスのロールを使えないようにする
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  # ECS_ENABLE_SPOT_INSTANCE_DRAINING: スポットの中断通知（2 分前）を受けたら、ECS がタスクを
  # 別のインスタンスへ移し、ALB からも外す
  user_data = base64encode(<<-EOT
    #!/bin/bash
    echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
    echo "ECS_ENABLE_SPOT_INSTANCE_DRAINING=${var.use_spot}" >> /etc/ecs/ecs.config
  EOT
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name      = "${var.name}-ecs"
      Project   = var.project_tag
      ManagedBy = "terraform"
    }
  }
}

resource "aws_autoscaling_group" "ecs" {
  name                = "${var.name}-ecs"
  min_size            = 1
  max_size            = 2 # デプロイ中に足りなくなったときと、スポットの差し替え中だけ 2 台目が起動する
  desired_capacity    = 1
  vpc_zone_identifier = var.public_subnet_ids
  health_check_type   = "EC2"

  # スポットの中断リスクが高まったという通知（リバランス推奨）を受けたら、中断される前に代わりを起動する
  capacity_rebalance = var.use_spot

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = var.use_spot ? 0 : 100
      # 価格が安く、かつ中断されにくい在庫から選ぶ
      spot_allocation_strategy = "price-capacity-optimized"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.ecs.id
        version            = "$Latest"
      }

      dynamic "override" {
        for_each = var.instance_types
        content {
          instance_type = override.value
        }
      }
    }
  }

  # ECS のキャパシティプロバイダーが管理していることを示すタグ
  tag {
    key                 = "AmazonECSManaged"
    value               = "true"
    propagate_at_launch = true
  }

  lifecycle {
    # 台数は ECS（マネージドスケーリング）が調整するので Terraform では触らない
    ignore_changes = [desired_capacity]
  }
}

resource "aws_ecs_capacity_provider" "ec2" {
  name = "${var.name}-ec2"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 100
    }
  }
}

# ===== ECS クラスター =====
resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name       = aws_ecs_cluster.main.name
  capacity_providers = [aws_ecs_capacity_provider.ec2.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ec2.name
    weight            = 1
  }
}
