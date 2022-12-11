
provider "aws"{
    #shared_config_files = ["C:\\Users\\wolnicki\\Documents\\.aws\\config"]
    #shared_credentials_files = ["C:\\Users\\wolnicki\\Documents\\.aws\\credentials"]
    shared_config_files = ["~/.aws/config"]
    shared_credentials_files = ["~/.aws/credentials"]

}


variable platform{}
variable instance_type{}
variable ssh_key{}
variable private_key_location{}
variable vpc_cidr_blocks {
    description = "cidr blocks and name tags for vpc"
    type = list(object({
        cidr_block = string
        name = string
    }))
}

variable subnet_cidr_blocks {
    description = "cidr blocks and name tags for subnets"
    type = list(object({
        cidr_block = string
        name = string
        az = string
    }))
}
resource "aws_vpc" "myapp-vpc"{
    cidr_block = var.vpc_cidr_blocks[0].cidr_block
    tags = {
        Name = "${var.vpc_cidr_blocks[0].name}"
        Platform = "${var.platform}-${var.platform}"
    }    
}

resource "aws_subnet" "myapp-subnet1"{
    vpc_id = "${aws_vpc.myapp-vpc.id}"
    cidr_block = "${var.subnet_cidr_blocks[0].cidr_block}"
    availability_zone = "${var.subnet_cidr_blocks[0].az}"
    tags = {
        Name = "${var.subnet_cidr_blocks[0].name}-${var.platform}"
        Platform = "${var.platform}"
    }


}

resource "aws_route_table" "myapp-routetable1"{
    vpc_id = "${aws_vpc.myapp-vpc.id}"    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.myapp-internetgateway.id}"
    }
    tags = {
        Name = "myapp-routetable1-${var.platform}"
    }
}

resource "aws_internet_gateway" "myapp-internetgateway" {
    vpc_id = "${aws_vpc.myapp-vpc.id}"
    tags ={
        Name = "myapp-igw-${var.platform}"
    }
}


resource "aws_route_table_association" "myapp-routetableassociation"{
    subnet_id = "${aws_subnet.myapp-subnet1.id}"
    route_table_id ="${aws_route_table.myapp-routetable1.id}"
}

resource "aws_security_group" "myapp-sg"{
    name = "myapp-sg"
    vpc_id = "${aws_vpc.myapp-vpc.id}"

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
        values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
    }
}

#Just to make sure that searchnig works fine
output "find_ami_id"{
    value = data.aws_ami.myapp_latest_amazon_linux_image.id
}

#It is worth to display public IP address
output "public_ip"{
    value = "${aws_instance.myapp-instance1.public_ip}"
}

resource "aws_instance" "myapp-instance1"{
    ami = "${data.aws_ami.myapp_latest_amazon_linux_image.id}"
    instance_type = "${var.instance_type}"
    subnet_id = "${aws_subnet.myapp-subnet1.id}"
    vpc_security_group_ids = ["${aws_security_group.myapp-sg.id}"]
    associate_public_ip_address = true
    key_name = "${var.ssh_key}"
    #user_data = file("user-data.sh")

    connection {
        type = "ssh"
        host = self.public_ip
        user = "ec2-user"
        private_key = file("${var.private_key_location}")
    }

#Provisioners are NOT recommended by Terraform !!!! :)
    provisioner "remote-exec"{
        inline = [
            "export ENV=dev",
            "mkdir /tmp/terraform_creates"
        ]
    }

    tags = {
        Name = "myapp-instance1-${var.platform}"
    }
}
