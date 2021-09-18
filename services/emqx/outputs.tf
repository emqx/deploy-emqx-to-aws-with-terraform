output "emqx_public_ips" {
  description = "public ip of ec2 for each project"
  value = module.emqx.public_ip
}

output "emqx_private_ips" {
  description = "private ip of ec2 for each project"
  value = module.emqx.private_ip
}