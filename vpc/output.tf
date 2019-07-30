output "vpc_id" {
    value = "${ibm_is_vpc.vpc.id}"
}
output "vpc_name" {
    value = "${ibm_is_vpc.vpc.name}"
}
output "vpc_status" {
    value = "${ibm_is_vpc.vpc.status}"
}
output "vpc_default_security_group" {
    value = "${ibm_is_vpc.vpc.default_security_group}"
}
output "subnet_id"{
    value = "${ibm_is_subnet.subnet.id}"
}
output "subnet_status"{
    value = "${ibm_is_subnet.subnet.status}"
}

output "public_gateway_status"{
    value = "${ibm_is_public_gateway.public_gateway.*.status}"
}

output "public_gateway_id"{
    value = "${ibm_is_public_gateway.public_gateway.*.id}"
}

output "public_gateway_floating_ip_info"{
    value = "${ibm_is_public_gateway.public_gateway.*.floating_ip}"
}

output "vpc_new_security_group_id" {
    value = "${ibm_is_security_group.security_group.id}"
}

