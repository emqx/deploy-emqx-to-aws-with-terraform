resource "aws_subnet" "sn" {
  for_each = var.zone

  vpc_id = var.vpc_id
  # Note: nlb doesn't work in some available zones
  availability_zone = each.key
  # 2,048 IP addresses each
  cidr_block = cidrsubnet(var.cidr_block, 4, each.value)

  tags = {
    Name = "${var.namespace}-sn"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id
  }

  tags = {
    Name = "${var.namespace}-rt"
  }
}

resource "aws_route_table_association" "rt_asso" {
  for_each = aws_subnet.sn

  subnet_id      = each.value.id
  route_table_id = aws_route_table.rt.id
}
