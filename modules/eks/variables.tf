
variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "office_sg_id" {
  type = string
}

variable "ssh_key_name" {
  type = string
}

