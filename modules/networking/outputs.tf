# output "vpc_id" {
#   description = "the id of vpc"
#   value       = aws_default_vpc.default.id
# }

# output "subnet_ids" {
#   description = "the ids of subnet"
#   value       = data.aws_subnet_ids.emqx.ids
# }

output "subnet_ids" {
  description = "the ids of subnet"
  value       = aws_subnet.sn[*].id
}

