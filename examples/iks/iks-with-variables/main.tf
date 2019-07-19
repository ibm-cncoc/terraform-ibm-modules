provider "ibm" {
  ibmcloud_api_key    = "${var.ibm_bx_api_key}"
  softlayer_username = "${var.ibm_sl_username}"
  softlayer_api_key  = "${var.ibm_sl_api_key}"
}

####### Call the module with variable arguments #######
module "iks" {
  source = "../../../iks"  # use if module is cloned locally
  # source = "github.com/ibm-client-success/terraform-ibm-modules.git//iks"
  resource_group    = "${var.resource_group}"
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
  delete_keys       = "${var.delete_keys}"
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