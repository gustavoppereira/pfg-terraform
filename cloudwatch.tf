resource "aws_cloudwatch_log_group" "app" {
  name  = "/ecs/service"
}

resource "aws_cloudwatch_log_stream" "app" {
  name  = "app"
  log_group_name = aws_cloudwatch_log_group.app.name
}

resource "aws_cloudwatch_log_group" "monitor" {
  name  = "/ecs/monitor"
}

resource "aws_cloudwatch_log_stream" "prometheus" {
  name  = "prometheus"
  log_group_name = aws_cloudwatch_log_group.monitor.name
}
