resource "aws_ecs_task_definition" "app" {
  family                = "app-task"
  container_definitions = file("files/service.json")
  network_mode          = "awsvpc"

  requires_compatibilities = ["EC2"]

  tags = {
    ManagedBy = "Terraform2"
    Type      = "http2"
  }
}

resource "aws_ecs_task_definition" "monitor" {
  family                = "monitor-task"
  #container_definitions = file("files/monitor.json")

  container_definitions = <<-DEFINITION
  [{
    "name": "prometheus",
    "image": "ragazzid/gus:final2",

    "memory": 512,
    "portMappings": [{
      "containerPort": 9090,
      "hostPort": 9090
    }],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/monitor",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "prometheus"
      }
    },

    "environment": [{
        "name": "IAM_ROLE_ARN",
        "value": "${aws_iam_role.app.arn}"
    }]
  }]
  DEFINITION

  network_mode          = "awsvpc"

  task_role_arn = aws_iam_role.app.arn

  requires_compatibilities = ["EC2"]

  tags = {
    ManagedBy = "Terraform2"
    Type      = "http2"
  }
}
