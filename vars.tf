variable "vpc_id" {
  default = "vpc-be3ae0c3"
}

variable "subnets" {
  default = ["subnet-58ffbf56", "subnet-db8612fa"]
}

variable "security_group_id" {
  default = "sg-d3ffe1e5"
}

variable "ami_id" {
  default = "ami-0f06fc190dd71269e"
}
