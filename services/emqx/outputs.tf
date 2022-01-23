output "emqx_address" {
  description = "public ip of ec2 for each project"
  value       = module.emqx.public_ip
}

# output "emqx_private_ip" {
#   description = "private ip of ec2 for each project"
#   value = module.emqx.private_ip
# }