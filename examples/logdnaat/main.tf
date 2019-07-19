provider "ibm" {
  ibmcloud_api_key    = "${var.ibm_bx_api_key}"
}

module "logdnaat" {
  # source            = "../../logdnaat" #use if module is cloned locally
  source            = "github.com/ibm-client-success/terraform-ibm-modules.git//logdnaat"
  pfx               = "tf"
  region            = "us-south"
  resource_group    = "default"
  tags              = ["terraform"]
  logdnaat_details  = { name = "at-logdna", plan = "lite"}
  cf_org            = "${var.cf_org}"
  cf_space          = "${var.cf_space}"
  cluster_name      = ""    #if you don't want to install logdna-AT agent in your cluster, keep it empty string
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
#   }

output "logDNA-AT-instance" {
  value = "${module.logdnaat.logDNA-AT-instance}"
}