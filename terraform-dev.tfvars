platform = "dev"
instance_type = "t2.micro"
ssh_key = "fidomwolnAWS"

vpc_cidr_blocks = [
    {
        cidr_block = "10.0.0.0/16"
        name = "vpc_ter"
    
    }
]

subnet_cidr_blocks = [
    {
        cidr_block = "10.0.1.0/24"
        name = "sub1_ter"
        az = "eu-west-1a"

    }
]