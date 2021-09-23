provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key

  default_tags {
    tags = {
      Name        = "tf-emqx"
      Product     = "emqx"
      Environment = "tf"
    }
  }
}
