# data "aws_availability_zones" "available" {
#   state = "available"
# }

# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"
#   name                             = "${var.namespace}-vpc"
#   cidr = var.cidr
#   azs                              = data.aws_availability_zones.available.names
#   private_subnets = var.private_subnets
#   public_subnets = var.public_subnets
# }


# resource "aws_default_vpc" "default" {
#   tags = {
#     Name = "Default VPC"
#   }
# }

# data "aws_subnet_ids" "emqx" {
#   vpc_id = aws_default_vpc.default.id
# }

data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_subnet" "sn" {
  count = length(var.subnet_cidr_blocks)

  vpc_id            = var.vpc_id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = var.subnet_cidr_blocks[count.index]
  tags = {
    Name = "${var.namespace}-sn"
  }
}
