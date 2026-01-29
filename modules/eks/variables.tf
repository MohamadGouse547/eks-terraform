variable "environment" {}
variable "vpc_id" {}
variable "private_subnets" {
  type = list(string)
}
variable "office_sg_id" {}
variable "ssh_key_name" {}
variable "terraform_role_arn" {
  type = string
}

