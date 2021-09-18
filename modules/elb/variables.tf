variable "namespace" {
  type = string
}

variable "sg_ids" {
  type = list(string)
}

variable "instance_count" {
  type = number
}

variable "subnet_ids" {
  type = list(string)
}

variable "instance_ids" {
  type = list(string)
}