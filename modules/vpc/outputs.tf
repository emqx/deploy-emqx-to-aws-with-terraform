output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "gw_id" {
  description = "The ID of internet gateway"
  value       = aws_internet_gateway.gw.id
}