# 共有 VPC の値（app・database レイヤーがこのレイヤーだけを読めば済むようにそのまま渡す）
output "vpc_id" {
  value = local.vpc_id
}

output "public_subnet_ids" {
  value = data.terraform_remote_state.shared_network.outputs.public_subnet_ids
}

output "private_subnet_ids" {
  value = data.terraform_remote_state.shared_network.outputs.private_subnet_ids
}

# 本番用の SG
output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "ecs_instances_security_group_id" {
  value = aws_security_group.ecs_instances.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}
