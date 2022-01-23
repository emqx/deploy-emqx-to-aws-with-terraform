output "emqx_cluster_address" {
  description = "dns name of the elb"
  value       = module.elb.elb_dns_name
}