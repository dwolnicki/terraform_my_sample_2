

resource "aws_security_group" "myapp-sg"{
    name = "myapp-sg"
    #vpc_id = "${aws_vpc.myapp-vpc.id}"
    vpc_id = "${var.vpc_id}"

    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress{
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "myapp-sg-${var.platform}"
    }

}

data "aws_ami" "myapp_latest_amazon_linux_image"{
    most_recent = "true"
    owners = ["137112412989"]

    filter{
        name = "name"
        values = ["${var.image_regex}"]
    }
}



resource "aws_instance" "myapp-instance1"{
    ami = data.aws_ami.myapp_latest_amazon_linux_image.id
    instance_type = "${var.instance_type}"
    #subnet_id = "${aws_subnet.myapp-subnet1.id}"
    #subnet_id = module.myapp-subnet.subnet.id 
    subnet_id = "${var.subnet_id}"
    vpc_security_group_ids = ["${aws_security_group.myapp-sg.id}"]
    associate_public_ip_address = true
    key_name = "${var.ssh_key}"
    user_data = file("user-data.sh")

    tags = {
        Name = "myapp-instance1-${var.platform}"
    }
}