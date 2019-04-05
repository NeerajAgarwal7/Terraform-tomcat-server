provider "aws" {
  region = "${var.region}"
}

data "aws_availability_zones" "available" {}

resource "aws_instance" "terraform_ec2" {
  count 	= "${var.ec2_count}"
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name	= "${var.key_pair}"
  security_groups = ["${aws_security_group.terraform-ec2-security.name}"]

  provisioner "file" {
    source      = "tomcat.service"
    destination = "/tmp/tomcat.service"
  }

  connection {
   user     = "ubuntu"
   private_key="${file("/home/ubuntu/secrets/devops-jan.pem")}"
  }

  provisioner "file" {
    source      = "WebApp.war"
    destination = "/tmp/WebApp.war"
  }

  connection {
   user     = "ubuntu"
   private_key="${file("/home/ubuntu/secrets/devops-jan.pem")}"
  }

  provisioner "remote-exec" {
    script =  "tomcat_install.sh"
  }

  connection {
   user     = "ubuntu"
   private_key="${file("/home/ubuntu/secrets/devops-jan.pem")}"
  }
tags = {
    Name = "tomcat"
  }

}

resource "aws_elb" "terraform_elb" {
  name               = "terraform-elb"
  availability_zones = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}", "${data.aws_availability_zones.available.names[2]}"]
  listener {
    instance_port     = 8080
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

  instances = ["${aws_instance.terraform_ec2.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "terraform-elb"
  }
}

#resource "aws_elb_attachment" "terraform_elb_atc" {
#  elb      = "${aws_elb.terraform_elb.id}"
#  instance = "${aws_instance.terraform_ec2.id}"
#}


output "instance_ids" {
    value = ["${aws_instance.terraform_ec2.*.public_ip}"]
}
output "elb_dns_name" {
  value = "${aws_elb.terraform_elb.dns_name}"
}
