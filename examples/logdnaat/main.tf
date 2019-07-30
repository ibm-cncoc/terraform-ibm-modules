provider "ibm" {
  ibmcloud_api_key    = "${var.ibm_bx_api_key}"
}

module "logdnaat" {
  # source            = "../../logdnaat" #use if module is cloned locally
  source            = "github.com/ibm-client-success/terraform-ibm-modules.git//logdnaat"
  pfx               = "tf"
  region            = "${var.region}"
  resource_group    = "${var.resource_group}"
  tags              = ["terraform"]
  logdnaat_details  = { name = "at-logdna", plan = "lite"}
  cf_org            = "${var.cf_org}"
  cf_space          = "${var.cf_space}"
  cluster_name      = "${var.cluster_name}"    #if you want to install the agent in your cluster, provide the name and set install_agent to true
  install_agent     = true
}

# module "logdnaat" {
##   source            = "../../logdnaat"
#   source            = "github.com/ibm-client-success/terraform-ibm-modules.git//logdnaat"
#   pfx               = "${var.pfx}"
#   region            = "${var.region}"
#   resource_group    = "${var.resource_group}"
#   tags              = ["${var.tags}"]
#   logdnaat_details  = "${var.logdnaat_details}"
#   cf_org            = "${var.cf_org}"
#   cf_space          = "${var.cf_space}"
#   cluster_name      = "${var.cluster_name}"
#   install_agent     = "${var.install_agent}"
#   }

output "logDNA_AT_instance_name" {
  value = "${module.logdnaat.logDNA_AT_instance_name}"
}

output "logDNA_AT_instance_id" {
  value = "${module.logdnaat.logDNA_AT_instance_id}"
}