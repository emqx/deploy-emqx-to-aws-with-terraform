resource "aws_vpc" "vpc" {
  cidr_block           = var.base_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "${var.emqx_namespace}-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.emqx_namespace}-gw"
  }
}