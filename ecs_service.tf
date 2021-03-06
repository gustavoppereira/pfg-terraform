
resource "aws_ecs_service" "app" {
  name            = "app-service"
  cluster         = aws_ecs_cluster.app.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1

  deployment_controller {
    type = "ECS"
  }

  capacity_provider_strategy {
    base              = 0
    capacity_provider = aws_ecs_capacity_provider.app.name
    weight            = 1
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "web"
    container_port   = 5000
  }

  network_configuration {
    subnets = var.subnets
  }
}

resource "aws_ecs_service" "monitor" {
  name            = "monitor-service"
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
    subnets = var.subnets
  }
}
