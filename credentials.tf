variable "aws_access_key" {}

variable "aws_secret_key" {}

resource "aws_key_pair" "deployer" {
  key_name = "${var.developer}"
  public_key = "${file("credentials/ssh/id_rsa.pub")}"
}

variable "developer" {}
