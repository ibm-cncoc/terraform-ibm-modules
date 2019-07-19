provider "ibm" {
  ibmcloud_api_key    = "${var.ibm_bx_api_key}"
}

data "ibm_resource_group" "rg" {
  name = "${var.resource_group}"
}

module "logdna" {
  # source            = "../../logdna"  #use if module is cloned locally
  source            = "github.com/ibm-client-success/terraform-ibm-modules.git//logdna"
  pfx               = "tf"
  region            = "us-south"
  resource_group    = "default"
  tags              = ["terraform"]
  logdna_details    = {"name"="logdna", "plan"="lite"}
  cluster_name      = ""     #if you don't want to install logdna agent in your cluster, give it empty string
}

### call using variables

# module "logdna" {
##   source            = "../../logdna"
#   source            = "github.com/ibm-client-success/terraform-ibm-modules.git//logdna"
#   pfx               = "${var.pfx}"
#   region            = "${var.region}"
#   resource_group    = "${var.resource_group}"
#   tags              = ["${var.tags}"]
#   logdna_details    = "${var.logdna_details}"
#   cluster_name      = "${var.cluster_name}"
# }

output "logDNA-instance" {
  value = "${module.logdna.logDNA-instance}"
}