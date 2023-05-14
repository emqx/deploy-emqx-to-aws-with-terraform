## common
region         = "us-east-1"
emqx_namespace = "tf-emqx-cluster"
elb_namespace  = "tf-elb"


## vpc
base_cidr_block = "10.0.0.0/16"
# Note: `value` will be `netnum` argument in cidrsubnet function
# Refer to https://www.terraform.io/language/functions/cidrsubnet
emqx_zone = { "us-east-1a" = 1 }
elb_zone  = { "us-east-1a" = 2 }


## ec2
associate_public_ip_address = true
emqx_instance_count         = 3
emqx_instance_type          = "t3.small"

## Cookie for emqx
emqx_cookie = "emqx_secret_cookie"


## special to emqx 4
emqx4_package = "https://www.emqx.com/en/downloads/enterprise/4.4.16/emqx-ee-4.4.16-otp24.3.4.2-1-ubuntu20.04-amd64.zip"

## special to emqx 5
# is_emqx5         = true
# emqx5_core_count = 1
# emqx5_package    = "https://www.emqx.com/en/downloads/broker/5.0.24/emqx-5.0.24-ubuntu20.04-amd64.tar.gz"
