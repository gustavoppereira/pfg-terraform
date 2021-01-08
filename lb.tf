resource "aws_lb" "app" {
  name               = "common-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = {
    Environment = "GusLindo"
  }
}

resource "aws_lb_target_group" "app" {
  name        = "app-lb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    interval  = 30
    path      = "/actuator/health"
    port      = 5000
    matcher   = "200-299"
  }

  depends_on = [aws_lb.app,]
}

resource "aws_lb_target_group" "monitor" {
  name        = "monitor-lb-tg"
  port        = 9090
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    interval  = 30
    path      = "/-/healthy"
    port      = 9090
    matcher   = "200-299"
  }

  depends_on = [aws_lb.app,]
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_lb_listener" "monitor" {
  load_balancer_arn = aws_lb.app.arn
  port              = "9090"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.monitor.arn
  }
}
