resource "aws_lb" "gus" {
  name               = "gustavo"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.vpc.default_security_group_id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = true

  tags = {
    Environment = "GusLindo"
  }
}

resource "aws_lb_target_group" "app" {
  name        = "gustavo-app-lb-tg-app"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
}

resource "aws_lb_target_group" "monitor" {
  name        = "gustavo-app-lb-tg-monitor"
  port        = 9090
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
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

resource "aws_lb_listener" "monitor" {
  load_balancer_arn = aws_lb.gus.arn
  port              = "9090"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.monitor.arn
  }
}
