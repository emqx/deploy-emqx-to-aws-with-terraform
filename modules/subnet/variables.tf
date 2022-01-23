variable "namespace" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "vpc_id" {
  type = string
}

# variable "subnet_number_set" {
#   type = set(number)
# }

variable "zone" {
  type = map(number)
}

variable "gateway_id" {
  type = string
}