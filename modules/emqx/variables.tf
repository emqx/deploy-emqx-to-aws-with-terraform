variable "namespace" {
  type = string
}

variable "sg_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "associate_public_ip_address" {
  type = bool
}

variable "instance_type" {
  type = string
}

variable "emqx_package" {
  type = string
}

variable "ee_lic" {
  type = string
}