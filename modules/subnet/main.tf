resource "aws_subnet" "myapp-subnet1"{
    vpc_id = "${var.vpc_id}"
    cidr_block = "${var.subnet_cidr_blocks[0].cidr_block}"
    availability_zone = "${var.subnet_cidr_blocks[0].az}"
    tags = {
        Name = "${var.subnet_cidr_blocks[0].name}-${var.platform}"
        Platform = "${var.platform}"
    }


}

resource "aws_route_table" "myapp-routetable1"{
    vpc_id = "${var.vpc_id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.myapp-internetgateway.id}"
    }
    tags = {
        Name = "myapp-routetable1-${var.platform}"
    }
}

resource "aws_internet_gateway" "myapp-internetgateway" {
    vpc_id = "${var.vpc_id}"
    tags ={
        Name = "myapp-igw-${var.platform}"
    }
}


resource "aws_route_table_association" "myapp-routetableassociation"{
    subnet_id = "${aws_subnet.myapp-subnet1.id}"
    route_table_id ="${aws_route_table.myapp-routetable1.id}"
}
