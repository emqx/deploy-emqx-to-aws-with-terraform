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
emqx_package                = "https://www.emqx.com/en/downloads/enterprise/4.4.3/emqx-ee-4.4.3-otp24.1.5-3-ubuntu20.04-amd64.zip"


