locals {
  ingress_rules = var.ingress_with_cidr_blocks
  egress_rules  = var.egress_with_cidr_blocks
}

resource "aws_security_group" "sg" {
  name        = "${var.namespace}-sg"
  description = "Allow inbound and outbound traffic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = [ingress.value.cidr_blocks]
    }
  }

  dynamic "egress" {
    for_each = local.egress_rules

    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = [egress.value.cidr_blocks]
    }
  }

  tags = {
    Name = "${var.namespace}-sg"
  }
}
