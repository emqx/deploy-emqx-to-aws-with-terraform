# Default VPC

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

#######################################
## emqx modules
#######################################

module "emqx_networking" {
  source = "../../modules/networking"

  namespace          = var.emqx_namespace
  region = var.region
  vpc_id             = aws_default_vpc.default.id
  subnet_cidr_blocks = var.subnet_cidr_blocks
}

module "emqx_security_group" {
  source = "../../modules/security_group"

  namespace                = var.emqx_namespace
  vpc_id                   = aws_default_vpc.default.id
  ingress_with_cidr_blocks = var.emqx_ingress_with_cidr_blocks
  egress_with_cidr_blocks  = var.egress_with_cidr_blocks
}

module "emqx" {
  source = "../../modules/emqx"

  namespace                   = var.emqx_namespace
  instance_type               = var.emqx_instance_type
  associate_public_ip_address = var.associate_public_ip_address
  subnet_ids                  = module.emqx_networking.subnet_ids
  sg_ids                      = [module.emqx_security_group.sg_id]
  emqx_package                = var.emqx_package
  emqx_lic                    = var.emqx_lic
}
