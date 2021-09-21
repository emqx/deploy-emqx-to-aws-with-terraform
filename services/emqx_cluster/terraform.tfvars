## common

emqx_namespace = "tf-emqx-cluster"

## vpc

emqx_ingress_with_cidr_blocks = [
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
  },
  {
    description = "cluster ekka"
    from_port   = 4370
    to_port     = 4370
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    description = "cluster rpc"
    from_port   = 5370
    to_port     = 5370
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }
]

egress_with_cidr_blocks = [
  {
    description = "all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
  }
]

elb_ingress_with_cidr_blocks = [
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
## ec2
associate_public_ip_address = true
emqx_instance_type          = "t2.micro"
