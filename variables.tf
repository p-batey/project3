variable "automation_pub_ip" {
  type    = string
  default = "184.73.107.156/32"
}

variable "instance-type" {
  type    = string
  default = "t2.micro"
}

variable "instance-ami" {
  type    = string
  default = "ami-0be2609ba883822ec"
}

variable "webserver-port" {
  type    = string
  default = "8080"
}
