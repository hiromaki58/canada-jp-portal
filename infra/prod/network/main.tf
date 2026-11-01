# ===== 共有 VPC（ステージングの network レイヤー infra/stg/network が管理） =====
# VPC とサブネットはステージングと共有する。このレイヤーは state を読むだけで、共有リソースは変更しない。
# ALB・ECS・RDS の SG は本番専用に作り、ステージングのリソースとは通信できないようにする。
data "terraform_remote_state" "shared_network" {
  backend = "s3"
  config = {
    bucket = "canada-jp-portal-tfstate-724775511010"
    key    = "stg/network/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  vpc_id = data.terraform_remote_state.shared_network.outputs.vpc_id
}
