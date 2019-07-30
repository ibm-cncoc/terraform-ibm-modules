provider "ibm" {
  ibmcloud_api_key    = "${var.ibm_bx_api_key}"
}

module "logdna" {
  # source            = "../../logdna" #use if module is cloned locally
  source            = "github.com/ibm-client-success/terraform-ibm-modules.git//logdna"
  pfx               = "tf"
  region            = "${var.region}"
  resource_group    = "${var.resource_group}"
  tags              = ["terraform"]
  logdna_details    = {"name"="logdna", "plan"="lite"}
  cluster_name      = "${var.cluster_name}" #if you want to install the agent in your cluster, provide the name and set install_agent to true
  install_agent     = true
}

output "logDNA_instance_name" {
  value = "${module.logdna.logDNA_instance_name}"
}

output "logDNA_instance_id" {
  value = "${module.logdna.logDNA_instance_id}"
}
