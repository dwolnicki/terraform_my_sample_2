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

variable platform{}
variable vpc_id{}