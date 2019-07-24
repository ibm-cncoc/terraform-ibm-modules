provider "ibm" {
  ibmcloud_api_key    = "${var.ibm_bx_api_key}"
}

################################################
# Example to avoid deleteion of keys. 
#################################################

# module "keyprotect" {
#   # source = "../../keyprotect"  # use if module is cloned locally
#   source = "github.com/ibm-client-success/terraform-ibm-modules.git//keyprotect"
#   kp_name           = "test-kps"
#   kp_rootkey        = {description="root key", payload= "****"}
#   ibm_bx_api_key    = "${var.ibm_bx_api_key}"
#   # resource_group    = "${var.resource_group}"
#   delete_keys       = false # Prohibits deletion of keys. Shows an error on `terraform destroy` as KP instance cannot be destroyed if keys are not gone
# }



module "keyprotect" {
  # source = "../../keyprotect"  # use if module is cloned locally
  source = "github.com/ibm-client-success/terraform-ibm-modules.git//keyprotect"
  kp_name           = "test-kps"
  kp_rootkey        = "${var.kp_rootkey}"
  ibm_bx_api_key    = "${var.ibm_bx_api_key}"
  resource_group    = "${var.resource_group}"
  delete_keys       = true # Allows deletion of all keys 
}

output "keyprotect_id" {
  value = "${module.keyprotect.keyprotect_id}"
}
output "keyprotect_name" {
  value = "${module.keyprotect.keyprotect_name}"
}
