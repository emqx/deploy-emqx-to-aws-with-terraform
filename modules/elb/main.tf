// local variables
locals {
    private_file = "tf-elb-key.pem"
}

// Private key pem
resource "tls_private_key" "key" {
  algorithm = "ECDSA"
  ecdsa_curve = "P384"
}

resource "local_file" "private_key" {
  filename          = "${path.module}/${local.private_file}"
  sensitive_content = tls_private_key.key.private_key_pem
  file_permission   = "0400"
}

// TLS certificate
resource "tls_cert_request" "elb" {
  key_algorithm   = "ECDSA"
  # private_key_pem = "${file("${path.module}/${local.private_file}")}"
  private_key_pem = "${file("tf-elb-key.pem")}"

  subject {
    organization = "EMQ"
  }
}

resource "tls_self_signed_cert" "elb" {
  key_algorithm   = "ECDSA"
  private_key_pem = "${file("tf-elb-key.pem")}"

  subject {
    organization = "EMQ"
  }

  validity_period_hours = 720

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth"
  ]
}

resource "aws_acm_certificate" "elb" {
  private_key      = tls_private_key.key.private_key_pem
  certificate_body = tls_self_signed_cert.elb.cert_pem
}

# resource "aws_lb" "emqx" {
#   name               = "${var.namespace}-elb"
#   internal           = true
#   load_balancer_type = "network"
#   security_groups    = [aws_security_group.lb_sg.id]
#   subnets            = aws_subnet.public.*.id
# }

# resource "aws_lb_listener" "emqx" {
#   load_balancer_arn = aws_lb.emqx.arn
#   port              = "443"
#   protocol          = "TLS"
#   certificate_arn   = aws_acm_certificate.elb.arn
#   alpn_policy       = "HTTP2Preferred"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.front_end.arn
#   }
# }

# resource "aws_lb_target_group_attachment" "emqx" {

#   target_group_arn = aws_lb_target_group.test.arn
#   target_id        = aws_instance.test.id
#   port             = 80
# }


# data "aws_instances" "emqx_cluster" {
#   instance_tags = {
#     Name = "${var.namespace}"
#   }
# }

module "elb" {
  source  = "terraform-aws-modules/elb/aws"
  version = "3.0.0"

  name = "${var.namespace}"

  subnets         = var.subnet_ids
  security_groups = var.sg_ids
  internal        = true

  listener = [
    {
      instance_port     = "18083"
      instance_protocol = "http"
      lb_port           = "18083"
      lb_protocol       = "http"

      #            Note about SSL:
      #            This line is commented out because ACM certificate has to be "Active" (validated and verified by AWS, but Route53 zone used in this example is not real).
      #            To enable SSL in ELB: uncomment this line, set "wait_for_validation = true" in ACM module and make sure that instance_protocol and lb_protocol are https or ssl.
      #            ssl_certificate_id = module.acm.acm_certificate_arn
    },
  ]

  health_check = {
    target              = "HTTP:18083/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  # ELB attachments
  number_of_instances = var.instance_count
  instances           = var.instance_ids
}