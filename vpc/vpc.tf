data "ibm_resource_group" "rg" {
  name = "${var.resource_group}"
}

# create a vpc resource
###############################################################
resource "ibm_is_vpc" "vpc" {
  name                = "${var.pfx}-${var.vpc_name}"
  resource_group      = "${data.ibm_resource_group.rg.id}"
  tags                = "${var.tags}"
}
###############################################################

# create a single-zone subnet
###############################################################
resource "ibm_is_subnet" "subnet" {
  name            = "${var.pfx}-${var.subnet_name}"
  vpc             = "${ibm_is_vpc.vpc.id}"
  zone            = "${var.region}-${var.zone_index}"
  ipv4_cidr_block = "${var.ipv4_cidr_block}"
  public_gateway =  "${var.create_gateway ? "${local.gateway_id}": ""}"

  provisioner "local-exec" {
    command = "sleep 90"
    when    = "destroy"
  }
  depends_on = ["ibm_is_public_gateway.public_gateway"]
}
locals {
  gateway_id = "${join("",ibm_is_public_gateway.public_gateway.*.id)}"

}

###############################################################

# create a security group for vpc along with inbound rules with protocols
###############################################################
resource "ibm_is_security_group" "security_group" {
    name = "${var.pfx}-${var.secgroup_name}"
    vpc = "${ibm_is_vpc.vpc.id}"
}

resource "ibm_is_security_group_rule" "security_group_rule_all" {
    count = "${length(var.protocols) == 0 ? 1 : 0}"  
    group = "${ibm_is_security_group.security_group.id}"
    direction = "${var.direction}"
    remote = "${var.remote}"
    ip_version = "${var.ip_version}"
 }

 resource "ibm_is_security_group_rule" "security_group_rule_udp" {
    count = "${contains(var.protocols, "udp") ? 1 : 0}"  
    group = "${ibm_is_security_group.security_group.id}"
    direction = "${var.direction}"
    remote = "${var.remote}"
    udp   = ["${var.udp_protocol}"]
    ip_version = "${var.ip_version}"
 }

 resource "ibm_is_security_group_rule" "security_group_rule_icmp" {
    count = "${contains(var.protocols, "icmp") ? 1 : 0}"  
    group = "${ibm_is_security_group.security_group.id}"
    direction = "${var.direction}"
    remote = "${var.remote}"
    icmp   = ["${var.icmp_protocol}"]
    ip_version = "${var.ip_version}"
 }

 resource "ibm_is_security_group_rule" "security_group_rule_tcp" {
    count = "${contains(var.protocols, "tcp") ? 1 : 0}"  
    group = "${ibm_is_security_group.security_group.id}"
    direction = "${var.direction}"
    remote = "${var.remote}"
    tcp   = ["${var.tcp_protocol}"]
    ip_version = "${var.ip_version}"
 }
 ###############################################################
 
# create a public gateway resource which will be attached to the created subnet
###############################################################
resource "ibm_is_public_gateway" "public_gateway" {
    count = "${var.create_gateway ? 1 : 0}"
    name = "${var.pfx}-${var.pubgateway_name}"
    vpc = "${ibm_is_vpc.vpc.id}"
    zone = "${var.region}-${var.zone_index}"

    //User can configure timeouts
    timeouts {
        create = "90m"
    }
}
