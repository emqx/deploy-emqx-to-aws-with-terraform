locals {
  timestamp       = formatdate("DD-MMM-YYYY-hh:mm", timestamp())
  emqx_anchor     = element(aws_instance.ec2[*].private_ip, 0)
  emqx_rest       = slice(aws_instance.ec2[*].public_ip, 1, var.instance_count)
  emqx_rest_count = var.instance_count - 1
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

// ssh certificate
resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "local_file" "private_key" {
  filename          = "${path.module}/tf-emqx-key.pem"
  sensitive_content = tls_private_key.key.private_key_pem
  file_permission   = "0400"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "tf-emqx-single-key"
  public_key = tls_private_key.key.public_key_openssh
}

// Configure the EC2 instance in a public subnet
resource "aws_instance" "ec2" {
  count = var.instance_count

  ami = data.aws_ami.ubuntu.id
  // always be true as you have to get public ip
  associate_public_ip_address = var.associate_public_ip_address
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids      = var.sg_ids
  key_name                    = aws_key_pair.key_pair.key_name

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.key.private_key_pem
  }

  # scp emqx
  provisioner "file" {
    source      = var.emqx_package
    destination = "/tmp/emqx.zip"
  }

  # init system
  provisioner "file" {
    content     = templatefile("${path.module}/scripts/init.sh", { emqx_lic = var.emqx_lic, local_ip = self.private_ip })
    destination = "/tmp/init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/init.sh",
      "/tmp/init.sh",
    ]
  }

  # Note: validate the above variables, you have to start emqx separately
  provisioner "remote-exec" {
    inline = [
      "sudo /home/ubuntu/emqx/bin/emqx start"
      # "sudo curl -k https://13.251.133.132/xmeter_tools/script.sh | sh"
    ]
  }

  root_block_device {
    iops        = 3000
    throughput  = 125
    volume_size = 50
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.namespace}"
  }
}

resource "null_resource" "emqx_cluster" {
  count = local.emqx_rest_count

  connection {
    type        = "ssh"
    host        = local.emqx_rest[count.index % local.emqx_rest_count]
    user        = "ubuntu"
    private_key = tls_private_key.key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "/home/ubuntu/emqx/bin/emqx_ctl cluster join emqx@${local.emqx_anchor}"
    ]
  }
}