# output "public_ips" {
#   value = aws_instance.ec2.*.public_ip
# }

# output "private_ips" {
#   value = aws_instance.ec2.*.private_ip
# }

output "ids" {
  value = aws_instance.ec2.*.id
}