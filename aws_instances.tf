provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}

resource "aws_instance" "master" {

  ami = "${var.aws_ami}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.swarm.name}"]
  key_name = "${aws_key_pair.deployer.key_name}"

  connection {
    user = "ubuntu"
    private_key = "${file("${path.module}/credentials/ssh/id_rsa")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common",
      "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce",
      "sudo docker swarm init",
      "sudo docker swarm join-token --quiet worker > /home/ubuntu/token"
    ]
  }

  volume_tags = {
    Name = "${var.developer}-master-volume"
  }

  tags = { 
    Name = "${var.developer}-master-instance"
  }

}

resource "aws_instance" "slave" {

  ami = "${var.aws_ami}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.swarm.name}"]
  key_name = "${aws_key_pair.deployer.key_name}"
 
  connection {
    user = "ubuntu"
    private_key = "${file("${path.module}/credentials/ssh/id_rsa")}"
  }

  provisioner "file" {
    source = "${path.module}/credentials/ssh/id_rsa.pem"
    destination = "/home/ubuntu/id_rsa.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common",
      "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce",
      "sudo chmod 400 /home/ubuntu/id_rsa.pem",
      "sudo scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -i /home/ubuntu/id_rsa.pem ubuntu@${aws_instance.master.private_ip}:/home/ubuntu/token .",
      "sudo docker swarm join --token $(cat /home/ubuntu/token) ${aws_instance.master.private_ip}:2377"
    ]
  }

  volume_tags = {
    Name = "${var.developer}-slave-volume"
  }

  tags = { 
    Name = "${var.developer}-slave-instance"
  }

}
