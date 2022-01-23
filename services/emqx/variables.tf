## common

variable "region" {
  description = "AWS region"
  type        = string
  default     = ""
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
  default     = ""
}


## vpc
variable "base_cidr_block" {
  description = "base cidr block"
  type        = string
  default     = ""
}

variable "emqx_zone" {
  type = map(number)

  description = "Map of AZ to a number that should be used for emqx subnets"

  # Note: `value` will be `netnum` argument in cidrsubnet function
  # Refer to https://www.terraform.io/language/functions/cidrsubnet

  default = {}
}

variable "emqx_ingress_with_cidr_blocks" {
  description = "ingress of emqx with cidr blocks"
  type        = list(any)
  default = [
    {
      description = "ssh"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "mqtt"
      from_port   = 1883
      to_port     = 1883
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "mqtts"
      from_port   = 8883
      to_port     = 8883
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "ws"
      from_port   = 8083
      to_port     = 8083
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "wss"
      from_port   = 8084
      to_port     = 8084
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "dashboard"
      from_port   = 18083
      to_port     = 18083
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

variable "egress_with_cidr_blocks" {
  description = "egress with cidr blocks"
  type        = list(any)
  default = [
    {
      description = "all"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

## ec2

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = true
}

variable "emqx_package" {
  description = "emqx  installation package"
  type        = string
  default     = null
}

variable "emqx_instance_type" {
  description = "Instance type of emqx"
  type        = string
  default     = ""
}

variable "ee_lic" {
  description = "the content of the license"
  type        = string
  default     = ""
}
