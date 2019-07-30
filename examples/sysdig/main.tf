provider "ibm" {
  ibmcloud_api_key    = "${var.ibm_bx_api_key}"
}


module "sysdig" {
  source            = "../../sysdig"  #use if module is cloned locally
  # source = "github.com/ibm-client-success/terraform-ibm-modules.git//sysdig"
  pfx               = "tf"
  region            = "${var.region}"
  resource_group    = "${var.resource_group}"
  tags              = ["terraform"]
  sysdig            = {name = "sysdig", plan ="lite", namespace = "ibm-observe-sysdig"}
  cluster_name      = "${var.cluster_name}" #if you want to install the agent in your cluster, provide the name and set install_agent to true
  install_agent     = true

}

##### call using variables

# module "sysdig" {
##   source            = "../../sysdig"   #use if module is cloned locally
#   source = "github.com/ibm-client-success/terraform-ibm-modules.git//sysdig"
#   pfx               = "${var.pfx}"
#   region            = "${var.region}"
#   resource_group    = "${var.resource_group}"
#   tags              = ["${var.tags}"]
#   sysdig            = "${var.sysdig}"
#   cluster_name      = "${var.cluster_name}"
#   install_agent     = "${var.install_agent}"
# }

output "sysdig_instance_name" {
  value = "${module.sysdig.sysdig_instance_name}"
}

output "sysdig_instance_id" {
  value = "${module.sysdig.sysdig_instance_id}"
}
