#######################################
## vpc modules
#######################################

module "vpc" {
  source = "../../modules/vpc"

  emqx_namespace  = var.emqx_namespace
  base_cidr_block = var.base_cidr_block
}

#######################################
## subnets modules
#######################################

module "emqx_subnet" {
  source = "../../modules/subnet"

  namespace  = var.emqx_namespace
  vpc_id     = module.vpc.vpc_id
  cidr_block = var.base_cidr_block
  gateway_id = module.vpc.gw_id
  zone       = var.emqx_zone
}


#######################################
## security group modules
#######################################
module "emqx_security_group" {
  source = "../../modules/security_group"

  namespace                = var.emqx_namespace
  vpc_id                   = module.vpc.vpc_id
  ingress_with_cidr_blocks = var.emqx_ingress_with_cidr_blocks
  egress_with_cidr_blocks  = var.egress_with_cidr_blocks
}

module "emqx" {
  source = "../../modules/emqx"

  namespace                   = var.emqx_namespace
  instance_type               = var.emqx_instance_type
  associate_public_ip_address = var.associate_public_ip_address
  subnet_ids                  = module.emqx_subnet.subnet_ids
  sg_ids                      = [module.emqx_security_group.sg_id]
  emqx_package                = var.emqx_package
  ee_lic                      = var.ee_lic
}
