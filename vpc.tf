module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "pfg"
  cidr = "10.0.0.0/16"

  azs               = ["us-east-1a", "us-east-1b"]
  private_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets    = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = true

  tags = {
    ManagedBy   = "Terraform"
    Environment = "Prod"
  }
}

resource "aws_security_group_rule" "allow_all" {
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 9999
  protocol          = "tcp"
  security_group_id = module.vpc.default_security_group_id
}
