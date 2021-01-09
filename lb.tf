resource "aws_lb" "this" {
  name               = var.name_prefix
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.vpc.default_security_group_id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

  tags = {
    Environment = "PROD"
  }
}

resource "aws_lb_target_group" "app" {
  name     = "${var.name_prefix}-app-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  # target_type = "ip"

  health_check {
    interval = 30
    path     = "/actuator/health"
    port     = 5000
    matcher  = "200-299"
  }

  depends_on = [
    aws_lb.this
  ]
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_lb_target_group" "prometheus" {
  name     = "${var.name_prefix}-lb-tg-prometheus"
  port     = 9090
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  # target_type = "ip"

  health_check {
    interval = 30
    path     = "/-/healthy"
    port     = 9090
    matcher  = "200-299"
  }

  depends_on = [
    aws_lb.this
  ]
}

resource "aws_lb_listener" "prometheus" {
  load_balancer_arn = aws_lb.this.arn
  port              = "81"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus.arn
  }
}

resource "aws_lb_target_group" "grafana" {
  name     = "${var.name_prefix}-lb-tg-grafana"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  # target_type = "ip"

  health_check {
    interval = 30
    path     = "/api/health"
    port     = 3000
    matcher  = "200-299"
  }

  depends_on = [
    aws_lb.this
  ]
}

resource "aws_lb_listener" "grafana" {
  load_balancer_arn = aws_lb.this.arn
  port              = "82"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana.arn
  }
}

//resource "aws_lb_listener_rule" "prometheus" {
//  listener_arn = aws_lb_listener.prometheus.arn
//
//  action {
//    type = "forward"
//    target_group_arn = aws_lb_target_group.prometheus.arn
//  }
//
//  condition {
//    path_pattern {
//      values = ["/prometheus/*"]
//    }
//  }
//}
//
//resource "aws_lb_listener_rule" "grafana" {
//  listener_arn = aws_lb_listener.prometheus.arn
//
//  action {
//    type = "forward"
//    target_group_arn = aws_lb_target_group.grafana.arn
//  }
//
//  condition {
//    path_pattern {
//      values = ["/grafana/*"]
//    }
//  }
//}

