variable "namespace" {
  type = string
}

variable "subnet_cidr_blocks" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}