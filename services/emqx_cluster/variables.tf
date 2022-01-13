## common

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "aws region"
}

variable "access_key" {
  description = "AWS access key"
  type        = string
  default     = ""
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
  default     = ""
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

variable "base_cidr_block" {
  description = "base cidr block"
  type        = string
  default     = "10.0.0.0/16"
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

variable "emqx_zone" {
  type = map(number)

  description = "Map of AZ to a number that should be used for emqx subnets"

  # Note: `value` will be `netnum` argument in cidrsubnet function
  # Refer to https://www.terraform.io/language/functions/cidrsubnet

  default = {
    "us-east-1a" = 1
  }
}

variable "elb_zone" {
  type = map(number)

  description = "Map of AZ to a number that should be used for elb subnets"

  # Note: `value` will be `netnum` argument in cidrsubnet function
  # Refer to https://www.terraform.io/language/functions/cidrsubnet

  default = {
    "us-east-1a" = 2
  }
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
  default = ""
}

variable "emqx_package" {
  description = "emqx installation package"
  type        = string
  default     = ""
}

variable "ee_lic" {
  description = "the content of the license"
  type        = string
  default     = ""
}

variable "emqx_instance_count" {
  description = "Instance count of emqx"
  type        = number
  default     = 3
}

variable "emqx_instance_type" {
  description = "Instance type of emqx"
  type        = string
  default     = "t3.small"
}

## nlb
variable "forwarding_config" {
  description = "forwarding config of nlb"
  type        = map(any)
  default = {
    1883  = "TCP"
    8883  = "TCP"
    8083  = "TCP"
    8084  = "TCP"
    18083 = "TCP"
  }
}

variable "elb_ingress_with_cidr_blocks" {
  description = "ingress of elb with cidr blocks"
  type        = list(any)
  default     = [null]
}