data "aws_iam_policy_document" "app_role" {
  statement {
    sid = "1"

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "ecs-tasks.amazonaws.com"
      ]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_instance_profile" "app" {
  name = "${var.name_prefix}_app"
  role = aws_iam_role.app.name
}

resource "aws_iam_role" "app" {
  name = "${var.name_prefix}_app"
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.app_role.json
}
