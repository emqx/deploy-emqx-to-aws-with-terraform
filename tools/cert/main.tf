// local variables
locals {
    private_file = "tf-elb-key.pem"
}

// Private key pem
resource "tls_private_key" "key" {
  algorithm = "ECDSA"
  ecdsa_curve = "P384"
}

resource "local_file" "private_key" {
  filename          = "${path.module}/${local.private_file}"
  sensitive_content = tls_private_key.key.private_key_pem
  file_permission   = "0400"
}
