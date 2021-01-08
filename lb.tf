resource "aws_lb" "gus" {
  name               = "gus"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.subnets

  enable_deletion_protection = true

  tags = {
    Environment = "GusLindo"
  }
}

resource "aws_lb_target_group" "app" {
  name        = "gus-app-lb-tg-app"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "gusyes" {
  load_balancer_arn = aws_lb.gus.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
