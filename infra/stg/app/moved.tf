# リソースの定義を modules/app に移したときの、state 上の住所の付け替え。
# これがあるので、apply してもリソースは作り直されない（plan に "has moved to" と表示される）
moved {
  from = aws_lb.main
  to   = module.app.aws_lb.main
}

moved {
  from = aws_lb_target_group.backend
  to   = module.app.aws_lb_target_group.backend
}

moved {
  from = aws_lb_target_group.frontend
  to   = module.app.aws_lb_target_group.frontend
}

moved {
  from = aws_lb_listener.http
  to   = module.app.aws_lb_listener.http
}

moved {
  from = aws_lb_listener.https
  to   = module.app.aws_lb_listener.https
}

moved {
  from = aws_lb_listener_rule.api
  to   = module.app.aws_lb_listener_rule.api
}

moved {
  from = aws_route53_record.app
  to   = module.app.aws_route53_record.app
}

moved {
  from = aws_launch_template.ecs
  to   = module.app.aws_launch_template.ecs
}

moved {
  from = aws_autoscaling_group.ecs
  to   = module.app.aws_autoscaling_group.ecs
}

moved {
  from = aws_ecs_capacity_provider.ec2
  to   = module.app.aws_ecs_capacity_provider.ec2
}

moved {
  from = aws_ecs_cluster.main
  to   = module.app.aws_ecs_cluster.main
}

moved {
  from = aws_ecs_cluster_capacity_providers.main
  to   = module.app.aws_ecs_cluster_capacity_providers.main
}

moved {
  from = aws_cloudwatch_log_group.backend
  to   = module.app.aws_cloudwatch_log_group.backend
}

moved {
  from = aws_cloudwatch_log_group.frontend
  to   = module.app.aws_cloudwatch_log_group.frontend
}

moved {
  from = aws_ecs_task_definition.backend
  to   = module.app.aws_ecs_task_definition.backend
}

moved {
  from = aws_ecs_task_definition.frontend
  to   = module.app.aws_ecs_task_definition.frontend
}

moved {
  from = aws_ecs_service.backend
  to   = module.app.aws_ecs_service.backend
}

moved {
  from = aws_ecs_service.frontend
  to   = module.app.aws_ecs_service.frontend
}

moved {
  from = aws_iam_role.task_execution
  to   = module.app.aws_iam_role.task_execution
}

moved {
  from = aws_iam_role_policy_attachment.task_execution
  to   = module.app.aws_iam_role_policy_attachment.task_execution
}

moved {
  from = aws_iam_role_policy.task_execution_secrets
  to   = module.app.aws_iam_role_policy.task_execution_secrets
}

moved {
  from = aws_iam_role.ecs_instance
  to   = module.app.aws_iam_role.ecs_instance
}

moved {
  from = aws_iam_role_policy_attachment.ecs_instance
  to   = module.app.aws_iam_role_policy_attachment.ecs_instance
}

moved {
  from = aws_iam_instance_profile.ecs_instance
  to   = module.app.aws_iam_instance_profile.ecs_instance
}
