#It is worth to display public IP address
output "instance_public_ip"{
    value = "${module.myapp-instance.instance.public_ip}"
}