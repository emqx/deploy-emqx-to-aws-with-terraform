output "sg_id" {
  description = "The IDs of the emqx security gourp"
  value       = aws_security_group.allow_tls.id
}

