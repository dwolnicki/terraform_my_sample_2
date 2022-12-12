




resource "aws_vpc" "myapp-vpc"{
    cidr_block = var.vpc_cidr_blocks[0].cidr_block
    tags = {
        Name = "${var.vpc_cidr_blocks[0].name}"
        Platform = "${var.platform}-${var.platform}"
    }    
}

module "myapp-subnet"{
    source = "./modules/subnet"
    vpc_cidr_blocks = "${var.vpc_cidr_blocks}"
    subnet_cidr_blocks = "${var.subnet_cidr_blocks}"
    platform = "${var.platform}"
    vpc_id = "${aws_vpc.myapp-vpc.id}"
}


module "myapp-instance"{
    source = "./modules/webserver"
    vpc_id = "${aws_vpc.myapp-vpc.id}"
    instance_type = var.instance_type
    subnet_id = module.myapp-subnet.subnet.id
    ssh_key = var.ssh_key
    platform = var.platform
}