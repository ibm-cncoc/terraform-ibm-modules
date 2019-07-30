# This end to end plan invokes iks(single-zone cluster) along with logDNA, logDNA-AT, Sysdig and COS modules

provider "ibm" {
 ibmcloud_api_key    = "${var.ibm_bx_api_key}"
 softlayer_username = "${var.ibm_sl_username}"
 softlayer_api_key  = "${var.ibm_sl_api_key}"
}

#Use below code snippet to use randomly generated prefix
#######################################################
locals {
  pfx = "${var.pfx == "" ? "${random_pet.pfx.id}" : "${var.pfx}"}"
}

resource "random_pet" "pfx" {
 length = 1
}
###########################################################


### Example of Single-Zone cluster:
module "iks" {
 # source = "../../iks"  # use if module is cloned locally
 source = "github.com/ibm-client-success/terraform-ibm-modules.git//iks"
 resource_group    = "${var.resource_group}"
 cluster_name      = "test-cluster"
 pfx               = "${local.pfx}"
 region            = "${var.region}"
 tags              = ["terraform"]
 zones             = ["dal10"]
 
 create_private_vlan = false
 create_public_vlan  = false
 public_vlan         = { ids = ["1902"], router_hostnames = ["fcr01a"]}
 private_vlan        = {ids = ["2219"], router_hostnames = ["bcr01a"]}

 worker_pools_num    = 0
 create_keyprotect = true
 kp_name           = "keyprotect"
 kp_rootkey        = {description="root key", payload = ""} # payload = "<base64 encoded key material>" to provide your own key. When payload="", it creates a root key for you by default
 delete_keys       = true
 ibm_bx_api_key    = "${var.ibm_bx_api_key}"
}

output "cluster_id" {
 value       = "${module.iks.cluster_id}"
}

output "cluster_name" {
 value       = "${module.iks.cluster_name}"
}

output "keyprotect_id" {
 value       = "${module.iks.keyprotect_id}"
}

output "keyprotect_name" {
 value       = "${module.iks.keyprotect_name}"
}

###########################################################
module "logdna" {

#  source            = "../../logdna"  #use if module is cloned locally
 source            = "github.com/ibm-client-success/terraform-ibm-modules.git//logdna"
 pfx               = "${local.pfx}"
 region            = "${var.region}"
 resource_group    = "${var.resource_group}"
 tags              = ["terraform"]
 logdna_details    = {"name"="logdna", "plan"="lite"}
 cluster_name      = "${module.iks.cluster_name}"  #if you want to install the agent in your cluster, provide the name and set install_agent to true
 install_agent     = true
}

output "logDNA_instance_id" {
 value = "${module.logdna.logDNA_instance_id}"
}

output "logDNA_instance_name" {
 value = "${module.logdna.logDNA_instance_name}"
}

###########################################################
module "logdnaat" {
#  source            = "../../logdnaat" #use if module is cloned locally
 source            = "github.com/ibm-client-success/terraform-ibm-modules.git//logdnaat"
 pfx               = "${local.pfx}"
 region            = "${var.region}"
 resource_group    = "${var.resource_group}"
 tags              = ["terraform"]
 logdnaat_details  = { name = "at-logdna", plan = "lite"}
 cf_org            = "${var.cf_org}"
 cf_space          = "${var.cf_space}"
 cluster_name      = "${module.iks.cluster_name}"    #if you want to install the agent in your cluster, provide the name and set install_agent to true
 install_agent     = true
}

output "logDNA_AT_instance_id" {
 value = "${module.logdnaat.logDNA_AT_instance_id}"
}
output "logDNA_AT_instance_name" {
 value = "${module.logdnaat.logDNA_AT_instance_name}"
}

###########################################################
module "sysdig" {
#  source            = "../../sysdig"  #use if module is cloned locally
 source = "github.com/ibm-client-success/terraform-ibm-modules.git//sysdig"
 pfx               = "${local.pfx}"
 region            = "${var.region}"
 resource_group    = "${var.resource_group}"
 tags              = ["terraform"]
 sysdig            = {name = "sysdig", plan ="lite", namespace = "ibm-observe-sysdig"}
 cluster_name      = "${module.iks.cluster_name}" #if you want to install the agent in your cluster, provide the name and set install_agent to true
 install_agent     = true
}
output "sysdig_instance_id" {
value = "${module.sysdig.sysdig_instance_id}"
}

output "sysdig_instance_name" {
value = "${module.sysdig.sysdig_instance_name}"
}

###########################################################
module "cos" {
  # source = "../../cos"  # use if module is cloned locally
  source = "github.com/ibm-client-success/terraform-ibm-modules.git//cos"
  pfx                   = "${local.pfx}"
  cos_name              = "test"
  cos_plan              = "standard"
  cos_location          = "global"
  cos_tags              = ["terraform"]
  resource_group    = "${var.resource_group}"
  cos_parameters        = { "HMAC" = true }
  cos_resource_key_parameters = { "HMAC" = true }
  cos_service_credentials_role    = "Reader"
}

output "cos_instance_status" {
    value = "${module.cos.cos_instance_status}"
}

output "cos_instance_name" {
    value = "${module.cos.cos_instance_name}"
}

output "cos_instance_id" {
    value = "${module.cos.cos_instance_id}"
}
###########################################################



