## common

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "access_key" {
  description = "AWS access key"
  type        = string
  default     = null
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
  default     = null
}

variable "emqx_namespace" {
  description = "emqx namespace"
  type        = string
  default     = "tf-emqx"
}

variable "elb_namespace" {
  description = "elb namespace"
  type        = string
  default     = "tf-elb"
}

## vpc

variable "subnet_cidr_blocks" {
  description = "subnets of vpc"
  type        = list(string)
  default = [
    "172.31.101.0/24",
    "172.31.102.0/24",
    "172.31.103.0/24",
    "172.31.104.0/24",
    "172.31.105.0/24",
    "172.31.106.0/24",
    "172.31.107.0/24",
    "172.31.108.0/24",
    "172.31.109.0/24"
    # "172.31.110.0/24",
    # "172.31.111.0/24",
    # "172.31.112.0/24"
  ]
}

variable "emqx_ingress_with_cidr_blocks" {
  description = "ingress of emqx with cidr blocks"
  type        = list(any)
  default     = [null]
}

variable "egress_with_cidr_blocks" {
  description = "egress with cidr blocks"
  type        = list(any)
  default     = [null]
}

## ec2

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = true
}

variable "ami" {
  description = "AMI to use for the instance"
  // Get the ami from the output of the packer
  type    = string
  default = null
}

variable "emqx_package" {
  description = "emqx installation package"
  type        = string
  default     = null
}

variable "emqx_lic" {
  description = "the name of key"
  type        = string
  default     = null
}

variable "emqx_instance_count" {
  description = "Instance count of emqx"
  type        = number
  default     = 2
}

variable "emqx_instance_type" {
  description = "Instance type of emqx"
  type        = string
  default     = "t2.micro"
}