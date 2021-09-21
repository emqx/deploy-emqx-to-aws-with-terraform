resource "aws_lb" "lb" {
  name               = "${var.namespace}-nlb"
  internal           = false
  load_balancer_type = "network"
  # security_groups    = var.sg_ids
  subnets            = var.subnet_ids
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn       = aws_lb.lb.arn
  for_each = var.forwarding_config
  port                = each.key
  protocol            = each.value
  default_action {
    target_group_arn = "${aws_lb_target_group.tg[each.key].arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "tg" {
  for_each = var.forwarding_config
  name                  = "${var.namespace}-tg-${each.key}"
  port                  = each.key
  protocol              = each.value
  vpc_id                  = var.vpc_id
  target_type             = "instance"
  # deregistration_delay    = 90
  health_check {
      interval            = 30
      port                = each.key
      protocol            = "TCP"
      healthy_threshold   = 3
      unhealthy_threshold = 3
    }
}

resource "aws_lb_target_group_attachment" "tga1" {
  for_each = var.forwarding_config
  target_group_arn  = "${aws_lb_target_group.tg[each.key].arn}"
  port              = each.key
  target_id           = var.instance_ids[0]
}

resource "aws_lb_target_group_attachment" "tga2" {
  for_each = var.forwarding_config
  target_group_arn  = "${aws_lb_target_group.tg[each.key].arn}"
  port              = each.key
  target_id           = var.instance_ids[1]
}