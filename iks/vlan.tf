data "ibm_network_vlan" "private_vlan" {
  count = "${var.create_private_vlan ? 0 : length(var.zones)}"
  router_hostname = "${element(var.private_vlan["router_hostnames"], count.index)}.${element(var.zones, count.index)}"
  number = "${element(var.private_vlan["ids"], count.index)}"
}

data "ibm_network_vlan" "public_vlan" {
  count = "${var.create_public_vlan ? 0 : length(var.zones)}"
  router_hostname = "${element(var.public_vlan["router_hostnames"], count.index)}.${element(var.zones, count.index)}"
  number = "${element(var.public_vlan["ids"], count.index)}"
}


resource "ibm_network_vlan" "private_vlan_new" {
  count       = "${var.create_private_vlan ? length(var.zones) : 0}"
  name        = "${var.pfx}-${element(var.zones, count.index)}-pri"
  datacenter  = "${element(var.zones, count.index)}"
  type        = "PRIVATE"
}

resource "ibm_network_vlan" "public_vlan_new" {
  count       = "${var.create_private_vlan ? length(var.zones) : 0}"
  name        = "${var.pfx}-${element(var.zones, count.index)}-pub"
  datacenter  = "${element(var.zones, count.index)}"
  type        = "PUBLIC"
}

locals {
  private_vlan_ids = ["${split(",", var.create_private_vlan ? join(",", ibm_network_vlan.private_vlan_new.*.id) : join(",", data.ibm_network_vlan.private_vlan.*.id))}"]
  public_vlan_ids = ["${split(",", var.create_public_vlan ? join(",", ibm_network_vlan.public_vlan_new.*.id) : join(",", data.ibm_network_vlan.public_vlan.*.id))}"]
}


output "supplied-private-vlan-numbers" {
  value         =  ["${data.ibm_network_vlan.private_vlan.*.id}"]
  description   =  "VLAN IDs"
  
}
output "supplied-public-vlan-numbers" {
  value         =  ["${data.ibm_network_vlan.public_vlan.*.id}"]
  description   =  "VLAN IDs"
  
}
output "created-private-vlan-numbers" {
  value         =  ["${ibm_network_vlan.private_vlan_new.*.id}"]
  description   =  "VLAN IDs"
  
}
output "created-public-vlan-numbers" {
  value         =  ["${ibm_network_vlan.public_vlan_new.*.id}"]
  description   =  "VLAN IDs"
  
}