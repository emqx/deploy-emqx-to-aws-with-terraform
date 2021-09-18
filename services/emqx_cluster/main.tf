# Default VPC

data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}

#######################################
## emqx modules
#######################################

module "emqx_networking" {
  source = "../../modules/networking"

  namespace          = var.emqx_namespace
  vpc_id             = data.aws_vpc.default.id
  subnet_cidr_blocks = slice(var.subnet_cidr_blocks, 0, var.emqx_instance_count)
}

module "elb_networking" {
  source = "../../modules/networking"

  namespace          = var.elb_namespace
  vpc_id             = data.aws_vpc.default.id
  subnet_cidr_blocks = slice(var.subnet_cidr_blocks, var.emqx_instance_count, var.emqx_instance_count+1)
}

module "emqx_security_group" {
  source = "../../modules/security_group"

  namespace                = var.emqx_namespace
  vpc_id                   = data.aws_vpc.default.id
  ingress_with_cidr_blocks = var.emqx_ingress_with_cidr_blocks
  egress_with_cidr_blocks  = var.egress_with_cidr_blocks
}

module "emqx_cluster" {
  source = "../../modules/emqx_cluster"

  namespace                   = var.emqx_namespace
  instance_count              = var.emqx_instance_count
  instance_type               = var.emqx_instance_type
  associate_public_ip_address = var.associate_public_ip_address
  subnet_ids                  = module.emqx_networking.subnet_ids
  sg_ids                      = [module.emqx_security_group.sg_id]
  emqx_package                = var.emqx_package
  emqx_lic                    = var.emqx_lic
}

module "elb" {
  source = "../../modules/elb"

  namespace                   = var.elb_namespace
  instance_count              = var.emqx_instance_count
  subnet_ids                  = module.elb_networking.subnet_ids
  sg_ids                      = [data.aws_security_group.default.id]
  instance_ids = module.emqx_cluster.ids
}
