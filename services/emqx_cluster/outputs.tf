output "emqx_public_ips" {
  description = "public ip of emqx ec2"
  value       = module.emqx_cluster.public_ips
}

output "emqx_private_ips" {
  description = "private ip of emqx ec2"
  value       = module.emqx_cluster.private_ips
}

output "emqx_instance_ids" {
  description = "instance ids of emqx ec2"
  value       =  module.emqx_cluster.ids
}

output "elb_dns_name" {
  description = "dns name of the elb"
  value = module.elb.elb_dns_name
}