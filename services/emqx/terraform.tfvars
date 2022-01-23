## common

region         = "us-east-1"
emqx_namespace = "tf-emqx-single"

## vpc

base_cidr_block = "10.0.0.0/16"
# Note: `value` will be `netnum` argument in cidrsubnet function
# Refer to https://www.terraform.io/language/functions/cidrsubnet
emqx_zone = { "us-east-1a" = 1 }


## ec2
emqx_instance_type          = "t3.small"
associate_public_ip_address = true
emqx_package                = "https://www.emqx.com/en/downloads/broker/4.3.8/emqx-ubuntu20.04-4.3.8-amd64.zip"