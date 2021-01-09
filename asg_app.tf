resource "aws_launch_configuration" "app" {
  name                 = "${var.name_prefix}_app"
  image_id             = data.aws_ami.ecs.id
  iam_instance_profile = aws_iam_instance_profile.app.name
  security_groups      = [module.vpc.default_security_group_id]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${var.name_prefix}_web >> /etc/ecs/ecs.config"
  instance_type        = "t3.micro"
}

resource "aws_autoscaling_group" "app" {
  name = "${var.name_prefix}_app"

  protect_from_scale_in = "true" # Necessario

  vpc_zone_identifier  = module.vpc.public_subnets
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
  max_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }

  tag {
    key                 = var.tag_key
    value               = var.tag_value
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "App"
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "app" {
  name = "${var.name_prefix}_app"

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
