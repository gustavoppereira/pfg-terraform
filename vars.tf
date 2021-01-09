# variable "vpc_id" {
#   default = "vpc-8fcd68f2"
# }
#
# variable "subnets" {
#   default = ["subnet-4169b470", "subnet-c0971ea6"]
# }
#
# variable "security_group_id" {
#   default = "sg-6b666d5d"
# }

variable "name_prefix" {
  default = "cluster"
}

variable "tag_key" {
  default = "INSTANCE"
}

variable "tag_value" {
  default = "app"
}
