variable "vpc_id" {
  default = "vpc-8fcd68f2"
}

variable "subnets" {
  default = ["subnet-4169b470", "subnet-c0971ea6", "subnet-8b84c785", "subnet-080f9b29", "subnet-8fa5fcc2", "subnet-be5dd7e1"]
}

variable "security_group_id" {
  default = "sg-6b666d5d"
}
