# data "aws_availability_zones" "available" {
#   state = "available"
#   exclude_names = ["${var.region}b"]
# }

resource "aws_subnet" "sn" {
  count = length(var.subnet_cidr_blocks)

  vpc_id            = var.vpc_id
  # availability_zone = data.aws_availability_zones.available.names[count.index]
  // nlb doesn't work in some available zones
  availability_zone = "${var.region}a"
  cidr_block        = var.subnet_cidr_blocks[count.index]
  tags = {
    Name = "${var.namespace}-sn"
  }
}
