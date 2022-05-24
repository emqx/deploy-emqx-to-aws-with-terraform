locals {
  target_port     = [for key, value in var.forwarding_config : value.dest_port]
  target_port_ssl = [for key, value in var.forwarding_config_ssl : value.dest_port]
  dest_to_src     = zipmap([for key, value in var.forwarding_config : value.dest_port], [for key, value in var.forwarding_config : key])
  dest_to_src_ssl = zipmap([for key, value in var.forwarding_config_ssl : value.dest_port], [for key, value in var.forwarding_config_ssl : key])
}

resource "aws_lb" "lb" {
  name               = "${var.namespace}-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnet_ids
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  for_each          = var.forwarding_config
  port              = each.key
  protocol          = each.value.protocol
  default_action {
    target_group_arn = aws_lb_target_group.tg[each.key].arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "tg" {
  for_each    = var.forwarding_config
  name        = "${var.namespace}-tg-${each.value.dest_port}"
  port        = each.value.dest_port
  protocol    = each.value.protocol
  vpc_id      = var.vpc_id
  target_type = "instance"
  # deregistration_delay    = 90
  health_check {
    interval            = 30
    port                = each.value.dest_port
    protocol            = "TCP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "tga" {
  for_each = {
    for pair in setproduct(local.target_port, range(var.instance_count)) : "${pair[0]} ${pair[1]}" => {
      dest_port = pair[0]
      idx       = pair[1]
    }
  }

  target_group_arn = aws_lb_target_group.tg[local.dest_to_src[each.value.dest_port]].arn
  port             = each.value.dest_port
  target_id        = var.instance_ids[each.value.idx]
}

######################################
## create slef-signed ssl certificate
######################################
resource "random_string" "app_keystore_password" {
  length  = 16
  special = false
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "public_cert" {
  # key_algorithm         = "RSA"
  private_key_pem       = "${tls_private_key.key.private_key_pem}"
  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  dns_names = ["*.${var.region}.elb.amazonaws.com"]

  subject {
    common_name  = "*.${var.region}.elb.amazonaws.com"
    organization = "ORAG"
    province     = "STATE"
    country      = "COUNT"
  }
}

resource "aws_acm_certificate" "cert" {
  private_key      = "${tls_private_key.key.private_key_pem}"
  certificate_body = "${tls_self_signed_cert.public_cert.cert_pem}"
}


resource "aws_lb_listener" "listener_ssl" {
  load_balancer_arn = aws_lb.lb.arn
  for_each          = var.forwarding_config_ssl
  port              = each.key
  protocol          = each.value.protocol
  # certificate_arn   = var.certificate_arn
  certificate_arn   = aws_acm_certificate.cert.arn
  default_action {
    target_group_arn = aws_lb_target_group.tg_ssl[each.key].arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "tg_ssl" {
  for_each = var.forwarding_config_ssl
  name     = "${var.namespace}-tg-${each.value.dest_port}"
  port     = each.value.dest_port
  # protocol              = each.value.protocol
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "instance"
  # deregistration_delay    = 90
  health_check {
    interval            = 30
    port                = each.value.dest_port
    protocol            = "TCP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "tga_ssl" {
  for_each = {
    for pair in setproduct(local.target_port_ssl, range(var.instance_count)) : "${pair[0]}:${pair[1]}" => {
      dest_port = pair[0]
      idx       = pair[1]
    }
  }

  target_group_arn = aws_lb_target_group.tg_ssl[local.dest_to_src_ssl[each.value.dest_port]].arn
  port             = each.value.dest_port
  target_id        = var.instance_ids[each.value.idx]
}