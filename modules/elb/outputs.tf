output "elb_dns_name" {
  description = "The DNS name of the ELB"
  value       = aws_lb.lb.dns_name
}