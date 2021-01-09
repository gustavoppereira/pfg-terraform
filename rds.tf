resource "aws_db_subnet_group" "default" {
  name = "db-subnet-group"

  subnet_ids = module.vpc.public_subnets
}

resource "aws_db_instance" "app" {
  allocated_storage   = 20
  identifier          = "app-db"
  port                = 3306

  engine              = "mariadb"
  engine_version      = "10.4.8"
  instance_class      = "db.t2.micro"

  username            = "admin"
  password            = "password"

  db_subnet_group_name  = aws_db_subnet_group.default.id

  vpc_security_group_ids = [module.vpc.default_security_group_id]
}
