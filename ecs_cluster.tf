resource "aws_ecs_cluster" "gus_app" {
  name = "gus_app"
  tags = {
    ManagedBy = "Terraform"
    Type      = "http"
  }

  capacity_providers = [aws_ecs_capacity_provider.gus_app.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.gus_app.name
    weight            = 1
  }
}

resource "aws_ecs_cluster" "monitor" {
  name = "monitor-cluster"
  tags = {
    ManagedBy = "Terraform"
    Type      = "http"
  }

  capacity_providers = [aws_ecs_capacity_provider.monitor.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.monitor.name
    weight            = 1
  }
}
