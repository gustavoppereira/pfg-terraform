resource "aws_ecs_task_definition" "gus_app" {
  family                = "service"
  container_definitions = file("files/service.json")
  network_mode          = "awsvpc"

  requires_compatibilities = ["EC2"]

  tags = {
    ManagedBy = "Terraform2"
    Type      = "http2"
  }
}

resource "aws_ecs_task_definition" "monitor" {
  family                = "service"
  container_definitions = file("files/monitor.json")
  network_mode          = "awsvpc"

  requires_compatibilities = ["EC2"]

  tags = {
    ManagedBy = "Terraform2"
    Type      = "http2"
  }
}
