
output "vpc_id" {
    value = "${ibm_is_vpc.vpc.id}"
}

output "vpc_default_security_group" {
    value = "${ibm_is_vpc.vpc.default_security_group}"
}

output "vpc_status" {
    value = "${ibm_is_vpc.vpc.status}"
}

output "subnet_status"{
    value = "${ibm_is_subnet.subnet.status}"
}

output "public_gateway_status"{
    value = "${ibm_is_public_gateway.public_gateway.*.status}"
}

output "public_gateway_floating_ip_info"{
    value = "${ibm_is_public_gateway.public_gateway.*.floating_ip}"
}