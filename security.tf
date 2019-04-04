resource "aws_security_group" "terraform-ec2-security" {
  name        = "terraform-eks-security"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-ec2"
  }
}


resource "aws_security_group_rule" "terraform-cluster-ingress-node-tcp" {
  from_port                = 8080
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.terraform-ec2-security.id}"
  to_port                  = 8080
  type                     = "ingress"
cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "terraform-cluster-ingress-node-ssh" {
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.terraform-ec2-security.id}"
  to_port                  = 22
  type                     = "ingress"
cidr_blocks = ["0.0.0.0/0"]
}

