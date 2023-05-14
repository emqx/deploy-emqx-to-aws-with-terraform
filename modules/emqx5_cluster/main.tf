locals {
  timestamp        = formatdate("DD-MMM-YYYY-hh:mm", timestamp())
  replicant_count  = var.instance_count - var.core_count
  public_ips       = aws_instance.ec2[*].public_ip
  private_ips      = aws_instance.ec2[*].private_ip
  private_ips_json = jsonencode([for ip in local.private_ips : format("emqx@%s", ip)])


  public_core_ips       = slice(local.public_ips, 0, var.core_count)
  private_core_ips      = slice(local.private_ips, 0, var.core_count)
  private_core_ips_json = jsonencode([for ip in local.private_core_ips : format("emqx@%s", ip)])

  public_replicant_ips  = slice(local.public_ips, var.core_count, var.instance_count)
  private_replicant_ips = slice(local.private_ips, var.core_count, var.instance_count)
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

resource "local_sensitive_file" "private_key" {
  filename        = "${path.module}/tf-emqx-key.pem"
  content         = tls_private_key.key.private_key_pem
  file_permission = "0400"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "tf-emqx-cluster-key"
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


  root_block_device {
    iops        = 3000
    throughput  = 125
    volume_size = 50
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.namespace}-ec2"
  }
}

resource "null_resource" "emqx-core" {
  depends_on = [aws_instance.ec2]

  count = var.core_count
  connection {
    type        = "ssh"
    host        = local.public_core_ips[count.index]
    user        = "ubuntu"
    private_key = tls_private_key.key.private_key_pem
  }

  # create init script
  provisioner "file" {
    content = templatefile("${path.module}/scripts/init-core.sh", { local_ip = local.private_core_ips[count.index], ee_lic = var.ee_lic,
    cookie = var.cookie, core_nodes = local.private_core_ips_json, all_nodes = local.private_ips_json })
    destination = "/tmp/init.sh"
  }

  # download emqx
  provisioner "remote-exec" {
    inline = [
      "curl -L --max-redirs -1 -o /tmp/emqx.tar.gz ${var.emqx_package}"
    ]
  }

  # init system
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
    ]
  }
}

resource "null_resource" "emqx-replicant" {
  depends_on = [null_resource.emqx-core]

  count = local.replicant_count
  connection {
    type        = "ssh"
    host        = local.public_replicant_ips[count.index]
    user        = "ubuntu"
    private_key = tls_private_key.key.private_key_pem
  }

  # create init script
  provisioner "file" {
    content = templatefile("${path.module}/scripts/init-replicant.sh", { local_ip = local.private_replicant_ips[count.index], ee_lic = var.ee_lic,
    cookie = var.cookie, core_nodes = local.private_core_ips_json, all_nodes = local.private_ips_json })
    destination = "/tmp/init.sh"
  }

  # download emqx
  provisioner "remote-exec" {
    inline = [
      "curl -L --max-redirs -1 -o /tmp/emqx.tar.gz ${var.emqx_package}"
    ]
  }

  # init system
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
    ]
  }
}
