data "aws_iam_policy_document" "app_role" {
  statement {
    sid = "1"

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_instance_profile" "app" {
  name = "app"
  role = aws_iam_role.app.name
}

resource "aws_iam_role" "app" {
  name = "app"
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.app_role.json
}
