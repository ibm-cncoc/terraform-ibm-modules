provider "ibm" {
  ibmcloud_api_key    = "${var.ibm_bx_api_key}"
  softlayer_username = "${var.ibm_sl_username}"
  softlayer_api_key  = "${var.ibm_sl_api_key}"
}


### Example of Multi-Zone cluster

module "iks" {
  # source = "../../../iks"  # use if module is cloned locally
  source = "github.com/ibm-client-success/terraform-ibm-modules.git//iks"
  resource_group    = "${var.resource_group}"
  cluster_name      = "my-cluster"
  disk_encryption   = true
  pfx               = "module-test"
  region            = "${var.region}"
  tags              = ["terraform"]
  zones             = ["dal12","dal10"]
  
  create_private_vlan = false
  create_public_vlan  = false
  public_vlan{
        
        ids = ["1111","1111"]
        router_hostnames = ["fcr01a","fcr01a"]
    } 
  private_vlan{
        ids = ["2222","2222"]
        router_hostnames = ["bcr01a","bcr01a"]
    }

  worker_pools_num    = 2
  worker_pool_params  = {
    tag             = ["small","medium"]
    machine_flavor  = ["u2c.2x4","b2c.4x16"]
    hardware        = ["shared","shared"]
    workers         = ["2","1"]
    disk_encryption = ["false","false"]
  }
  create_keyprotect = true
  kp_name           = "keyprotect"
  kp_plan           = "tiered-pricing"
  kp_rootkey        = {description="root key for ICD DB", payload = ""} # payload = "<base64 encoded key material>" to provide your own key. When payload="", it creates a root key for you by default
  ibm_bx_api_key    = "${var.ibm_bx_api_key}"
  delete_keys       = true # deletes all keys on destroy (only matters if 'create_keyprotect = true')

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



