resource "aws_security_group" "swarm" {

  name = "${var.developer}-swarm-group"
  description = "Allow Remote access to SSH, HTTP, HTTPS, Docker API; Docker only from Private Network"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
	description = "Allow Remote SSH connections"
  }

  ingress {
    from_port = 2377
    to_port = 2377
    protocol = "tcp"
    cidr_blocks = ["172.16.0.0/12"]
	description = "Allow Remote Docker connections from Private Network"
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
	description = "Allow Remote HTTP connections"
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
	description = "Allow Remote HTTPS connections"
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self = true
	description = "Allow ALL outbound connections"
  }

  tags {
    Name = "${var.developer}" 
  }

}
