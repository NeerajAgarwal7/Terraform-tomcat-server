variable "region" {
	default = "ap-southeast-1"
}

variable "ec2_count"{
	default = 2
}

variable "ami_id"{
	default = "ami-0eb1f21bbd66347fe"
}

variable "instance_type"{
        default = "t2.micro"
}

variable "key_pair" {
	default = "devops-jan"
}
