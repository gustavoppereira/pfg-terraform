
resource "aws_ecs_service" "gus_app" {
  name            = "gus_app"
  cluster         = aws_ecs_cluster.gus_app.id
  task_definition = aws_ecs_task_definition.gus_app.arn
  desired_count   = 1
  # iam_role        = aws_iam_role.app.arn

  # ordered_placement_strategy {
  #   type  = "binpack"
  #   field = "cpu"
  # }
  #
  # load_balancer {
  #   target_group_arn = aws_lb_target_group.app.arn
  #   container_name   = "web"
  #   container_port   = 80
  # }

  network_configuration {
    subnets = ["subnet-58ffbf56", "subnet-db8612fa"]
  }

}
