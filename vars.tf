variable "vpc_id" {
  default = "vpc-8fcd68f2"
}

variable "subnets" {
  default = ["subnet-4169b470", "subnet-c0971ea6"]
}

variable "security_group_id" {
  default = "sg-6b666d5d"
}

variable "ami_id" {
  default = "ami-0f06fc190dd71269e"
}
