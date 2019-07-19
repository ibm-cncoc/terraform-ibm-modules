provider "ibm" {
  ibmcloud_api_key    = ""
  softlayer_username = ""
  softlayer_api_key  = ""
}


### Example of Single-Zone cluster:

module "iks" {
  # source = "../../../iks"  # use if module is cloned locally
  source = "github.com/ibm-client-success/terraform-ibm-modules.git//iks"
  resource_group    = "default"
  cluster_name      = "cluster"
  pfx               = "dev"
  region            = "us-south"
  tags              = ["terraform"]
  zones             = ["dal10"]
  
  create_private_vlan = false
  create_public_vlan  = false
  public_vlan         = { ids = ["1902"], router_hostnames = ["fcr01a"]}
  private_vlan        = {ids = ["2219"], router_hostnames = ["bcr01a"]}

  worker_pools_num    = 0
  create_keyprotect = true
  kp_name           = "keyprotect"
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



