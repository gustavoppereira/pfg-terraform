resource "aws_launch_configuration" "app" {
  name                 = "app-configuration"
  image_id             = data.aws_ami.ecs.id
  iam_instance_profile = aws_iam_instance_profile.app.name
  security_groups      = [var.security_group_id]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=app-cluster >> /etc/ecs/ecs.config"
  instance_type        = "t3.micro"

  #depends_on = [aws_ecs_cluster.app]
}

resource "aws_autoscaling_group" "app" {
  name = "app-scalling-group"

  protect_from_scale_in = "true" # Necessario

  vpc_zone_identifier  = var.subnets
  launch_configuration = aws_launch_configuration.app.name

  lifecycle {
    ignore_changes = [
      desired_capacity,
      min_size,
      max_size
    ]
  }
  desired_capacity          = 0
  min_size                  = 0
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }

  tag {
    key                 = "Gus"
    value               = "MeuLindo"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "App"
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "app" {
  name = "app-cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.app.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 100
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 4
    }
  }
}
