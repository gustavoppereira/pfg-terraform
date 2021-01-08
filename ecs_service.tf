
resource "aws_ecs_service" "ragazzid_app" {
  name            = "${var.name_prefix}_web"
  cluster         = aws_ecs_cluster.ragazzid_app.id
  task_definition = aws_ecs_task_definition.ragazzid_app.arn
  desired_count   = 1

  deployment_controller {
    type = "ECS"
  }

  capacity_provider_strategy {
    base              = 0
    capacity_provider = aws_ecs_capacity_provider.ragazzid_app.name
    weight            = 1
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "web"
    container_port   = 5000
  }

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [module.vpc.default_security_group_id]
  }
}

resource "aws_ecs_service" "monitor" {
  name            = "${var.name_prefix}_monitor"
  cluster         = aws_ecs_cluster.monitor.id
  task_definition = aws_ecs_task_definition.monitor.arn
  desired_count   = 1

  deployment_controller {
    type = "ECS"
  }

  capacity_provider_strategy {
    base              = 0
    capacity_provider = aws_ecs_capacity_provider.monitor.name
    weight            = 1
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.monitor.arn
    container_name   = "prometheus"
    container_port   = 9090
  }

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [module.vpc.default_security_group_id]
  }
}
