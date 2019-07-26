provider "ibm" {
  ibmcloud_api_key    = "${var.ibm_bx_api_key}"
  softlayer_username = "${var.ibm_sl_username}"
  softlayer_api_key  = "${var.ibm_sl_api_key}"
  # below parameters required for vpc
  generation = 1      # The generation of Virtual Private Cloud. 1 => classic infrastructure
  region = "${var.region}"
}

module "vpc" {
  # source            = "../../vpc" # use if module is cloned locally
  source            = "github.com/ibm-client-success/terraform-ibm-modules.git//vpc"
  vpc_name          = "vpc"
  subnet_name       = "subnet"
  secgroup_name     = "secgroup"
  pubgateway_name   = "pubgateway"
  pfx               = "test"
  resource_group    = "${var.resource_group}"
  ipv4_cidr_block   = "10.243.0.0/24"
  region            = "${var.region}"
  zone_index        = "1"
  tags              = ["terraform"]
  remote            = "127.0.0.1"
  direction         = "ingress"
  udp_protocol      = {
      port_min = 805
      port_max = 807
    }
  icmp_protocol     = {
      code = 20
      type = 30
    }
  tcp_protocol      = {
      port_min = 8080 
      port_max = 8080
  }
  create_gateway    = true
  protocols         = ["tcp","udp","icmp"]
  ip_version        = "ipv4"
}


output "vpc_id" {
    value = "${module.vpc.vpc_id}"
}
output "vpc_name" {
    value = "${module.vpc.vpc_name}"
}
output "vpc_status" {
    value = "${module.vpc.vpc_status}"
}
output "vpc_default_security_group" {
    value = "${module.vpc.vpc_default_security_group}"
}
output "subnet_id"{
    value = "${module.vpc.subnet_id}"
}
output "subnet_status"{
    value = "${module.vpc.subnet_status}"
}

output "public_gateway_status"{
    value = "${module.vpc.public_gateway_status}"
}

output "public_gateway_id"{
    value = "${module.vpc.public_gateway_id}"
}

output "public_gateway_floating_ip_info"{
    value = "${module.vpc.public_gateway_floating_ip_info}"
}
output "vpc_new_security_group_id" {
    value = "${module.vpc.vpc_new_security_group_id}"
}
