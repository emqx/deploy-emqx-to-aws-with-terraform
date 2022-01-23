output "subnet_ids" {
  description = "the ids of subnet"
  value       = [for v in aws_subnet.sn : v.id]
}
