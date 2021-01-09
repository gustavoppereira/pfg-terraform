data "template_file" "app" {
  template = file("files/service.json")
  vars = {
    DB_HOST       = aws_db_instance.app.endpoint
    TEST_GROUP_ID = uuid()
  }
}

resource "aws_ecs_task_definition" "app" {
  family                = "${var.name_prefix}_web"
  container_definitions = data.template_file.app.rendered
  network_mode          = "host"

  requires_compatibilities = ["EC2"]

  tags = {
    ManagedBy = "Terraform"
    Type      = "http"
  }
}


data "template_file" "monitor" {
  template = file("files/monitor.json")
  vars = {
    IAM_ROLE_ARN  = aws_iam_role.app.arn
    TAG_KEY       = var.tag_key
    TAG_VALUE     = var.tag_value
  }
}

resource "aws_ecs_task_definition" "monitor" {
  family                = "${var.name_prefix}_monitor"
  container_definitions = data.template_file.monitor.rendered
  network_mode          = "host"

  task_role_arn = aws_iam_role.app.arn

  requires_compatibilities = ["EC2"]

  tags = {
    ManagedBy = "Terraform"
    Type      = "http"
  }
}

resource "aws_ecs_task_definition" "grafana" {
  family                = "${var.name_prefix}_grafana"
  container_definitions = <<-DEFINITION
  [
    {
    "name": "grafana",
    "image": "grafana/grafana:6.5.0",
    "cpu": 1000,
    "memory": 512,
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/monitor",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "grafana"
      }
    }
  }]
  DEFINITION

  network_mode          = "host"

  #task_role_arn = aws_iam_role.app.arn

  requires_compatibilities = ["EC2"]

  tags = {
    ManagedBy = "Terraform"
    Type      = "http"
  }
}
