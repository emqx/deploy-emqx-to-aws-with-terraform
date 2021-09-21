variable "namespace" {
  type = string
}

# variable "sg_ids" {
#   type = list(string)
# }

variable "subnet_ids" {
  type = list(string)
}

variable "instance_ids" {
  type = list(string)
}

variable "forwarding_config" {
  type = map
}

variable "vpc_id" {
  type = string
}