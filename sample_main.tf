provider "ibm" {
  ibmcloud_api_key    = "${var.ibm_bx_api_key}"
  softlayer_username = "${var.ibm_sl_username}"
  softlayer_api_key  = "${var.ibm_sl_api_key}"
}

data "ibm_resource_group" "rg" {
  name = "${var.resource_group}"
}

data "ibm_org" "org" {
  org = "${var.cf_org}"
}

data "ibm_account" "account" {
  org_guid = "${data.ibm_org.org.id}"
}

############### Modules ##################

# ############## IKS ##################

module "iks" {
  source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//iks"

  account_guid      = "${data.ibm_account.account.id}"
  resource_group_id = "${data.ibm_resource_group.rg.id}"
  billing           = "${var.billing}"
  cluster_name      = "${var.cluster_name}"
  default_pool_size = "${var.default_pool_size}"
  disk_encryption   = "${var.disk_encryption}"
  hardware          = "${var.hardware}"
  kube_version      = "${var.kube_version}"
  machine_type      = "${var.machine_type}"
  pfx               = "${var.pfx}"
  region            = "${var.region}"
  tags              = ["${var.tags}"]
  zones             = "${var.zones}"
  
  create_private_vlan = "${var.create_private_vlan}"
  create_public_vlan  = "${var.create_public_vlan}"
  public_vlan         = "${var.public_vlan}"
  private_vlan        = "${var.private_vlan}"

  worker_pools_num    = "${var.worker_pools_num}"
  worker_pool_params  = "${var.worker_pool_params}"

  create_keyprotect = "${var.create_keyprotect}"
  kp_name           = "${var.kp_name}"
  kp_plan           = "${var.kp_plan}"
  kp_rootkey        = "${var.kp_rootkey}"
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


############### COS ################
module "cos" {
  source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//cos"
  
  pfx                   = "${var.pfx}"
  cos_name              = "${var.cos_name}"
  cos_plan              = "${var.cos_plan}"
  cos_location          = "${var.cos_location}"
  cos_tags              = ["${var.tags}"]
  resource_group_id     = "${data.ibm_resource_group.rg.id}"
  cos_parameters        = "${var.cos_parameters}"
  cos_resource_key_parameters = "${var.cos_resource_key_parameters}"
  cos_service_credentials_role    = "${var.cos_service_credentials_role}"
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