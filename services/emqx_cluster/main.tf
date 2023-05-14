
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

module "elb_subnet" {
  source = "../../modules/subnet"

  namespace  = var.elb_namespace
  vpc_id     = module.vpc.vpc_id
  cidr_block = var.base_cidr_block
  gateway_id = module.vpc.gw_id
  zone       = var.elb_zone
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

#######################################
## emqx modules
#######################################

module "emqx4_cluster" {
  count = var.is_emqx5 ? 0 : 1

  source = "../../modules/emqx4_cluster"

  namespace                   = var.emqx_namespace
  instance_count              = var.emqx_instance_count
  instance_type               = var.emqx_instance_type
  associate_public_ip_address = var.associate_public_ip_address
  subnet_ids                  = module.emqx_subnet.subnet_ids
  sg_ids                      = [module.emqx_security_group.sg_id]
  emqx_package                = var.emqx4_package
  ee_lic                      = var.emqx_lic
}

module "emqx5_cluster" {
  count = var.is_emqx5 ? 1 : 0

  source = "../../modules/emqx5_cluster"

  namespace                   = var.emqx_namespace
  instance_count              = var.emqx_instance_count
  core_count                  = var.emqx5_core_count
  instance_type               = var.emqx_instance_type
  associate_public_ip_address = var.associate_public_ip_address
  subnet_ids                  = module.emqx_subnet.subnet_ids
  sg_ids                      = [module.emqx_security_group.sg_id]
  emqx_package                = var.emqx5_package
  ee_lic                      = var.emqx_lic
  cookie                      = var.emqx_cookie
}

#######################################
## elb modules
#######################################

module "elb" {
  source = "../../modules/elb"

  namespace             = var.elb_namespace
  region                = var.region
  instance_count        = var.emqx_instance_count
  subnet_ids            = module.elb_subnet.subnet_ids
  certificate_arn       = var.certificate_arn
  forwarding_config     = var.forwarding_config
  forwarding_config_ssl = var.forwarding_config_ssl
  vpc_id                = module.vpc.vpc_id
  instance_ids          = var.is_emqx5 ? module.emqx5_cluster[0].ids : module.emqx4_cluster[0].ids
}
