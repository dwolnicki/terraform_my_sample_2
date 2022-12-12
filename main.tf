




#resource "aws_vpc" "myapp-vpc"{
#    cidr_block = var.vpc_cidr_blocks[0].cidr_block
#    tags = {
#        Name = "${var.vpc_cidr_blocks[0].name}"
#        Platform = "${var.platform}-${var.platform}"
#    }    
#
#}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc-from-module"
  cidr = "${var.vpc_cidr_blocks[0].cidr_block}"

  azs             = [var.subnet_cidr_blocks[0].az]
  public_subnets  = [var.subnet_cidr_blocks[0].cidr_block]


  tags = {
    Name = "VPC=${var.platform}"
    
  }
}




module "myapp-instance"{
    source = "./modules/webserver"
    #vpc_id = "${aws_vpc.myapp-vpc.id}"
    vpc_id = module.vpc.vpc_id #sprawdzilem na stronie terraform jakie mam outputs
    instance_type = "${var.instance_type}"
    #subnet_id = "${module.myapp-subnet.subnet.id}"
    subnet_id = module.vpc.public_subnets[0]
    ssh_key = "${var.ssh_key}"
    platform = "${var.platform}"
    image_regex = "${var.image_regex}"
}